`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date:    18:19:35 09/01/2013
// Design Name:
// Module Name:    PS2_reader
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
module PS2_Reader(
    input  CLK50MHZ,
    input  RST,
    input  ps2_clk_negedge,
    input  ready,
    output start_receiving,
    output scan_ready
    );

   localparam [2:0]
    WAIT_STARTBIT = 3'd0,
    START_RECEVING = 3'd1,
    RECEIVING = 3'd2,
    RECEIVED = 3'd3;

   reg [1:0]  state = WAIT_STARTBIT;
   always @(posedge CLK50MHZ)
     if(RST)
       state <= WAIT_STARTBIT;
     else
       case(state)
         WAIT_STARTBIT:
           if(ps2_clk_negedge)
             state <= START_RECEVING;
         START_RECEVING:
             state <= RECEIVING;
         RECEIVING:
           if(ready)
             state <= RECEIVED;
         RECEIVED:
             state <= WAIT_STARTBIT;
       endcase

    assign       start_receiving = (state == START_RECEVING);
    assign       scan_ready = (state == RECEIVED);

endmodule
