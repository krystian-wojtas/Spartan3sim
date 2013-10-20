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
    input  ps2_clk,
    input  ps2_data,
    output [7:0] scancode,
    output scan_ready
    );


   // Detect negative edge on input ps2 clock line

   wire ps2_clk_negedge;
   Edge_Detector edge_detector_ps2clk (
      .CLK50MHZ(CLK50MHZ),
      .line(ps2_clk),
      .neg(ps2_clk_negedge)
   );

   wire        trig;
   wire        ready;
   wire [9:0] data_out;
    Serial #(
        .WIDTH(11)
    ) Serial_ (
        .CLKB(CLK50MHZ),
        .RST(RST),
        // serial module interface
        .rx(ps2_data),
        .data_in(11'b0),
        .data_out(data_out),
        .trig(trig),
        .ready(ready),
        .tick(ps2_clk_negedge)
    );

   // Get rid of start, stop and odd bits
// TODO verify odd
// extra output err wire;
   assign scancode = data_out[9:2];

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

    assign       trig = (state == START_RECEVING);
    assign       scan_ready = (state == RECEIVED);

endmodule
