module Top (
    input  CLK50MHZ,
    input  RST,
    // mouse
    inout  PS2_CLK1,
    inout  PS2_DATA1,
    // user interface
    output reg [7:0] LED,
    // debug
    output DEBUG_A,
    output DEBUG_B
);

   // signal declaration
   reg [9:0] p_reg;
   wire [9:0] p_next;
   wire [8:0] xm;
   wire [2:0] btnm;
   wire m_done_tick;

   // body
   // instantiation
   Mouse_PS2 Mouse_PS2_
      (.clk(CLK50MHZ), .rst(RST), .ps2d(PS2_DATA1), .ps2c(PS2_CLK1),
       .xm(xm), .btnm(btnm),
       .m_done_tick(m_done_tick));

   // counter
   always @(posedge CLK50MHZ, posedge RST)
      if (RST)
         p_reg <= 0;
      else
         p_reg <= p_next;

   assign p_next = (~m_done_tick) ? p_reg  : // no activity
                   (btnm[0])      ? 10'b0  : // left button
                   (btnm[1])     ? 10'h3ff : // right button
                   p_reg + {xm[8], xm};      // x movement

   always @*
      case (p_reg[9:7])
         3'b000: LED = 8'b10000000;
         3'b001: LED = 8'b01000000;
         3'b010: LED = 8'b00100000;
         3'b011: LED = 8'b00010000;
         3'b100: LED = 8'b00001000;
         3'b101: LED = 8'b00000100;
         3'b110: LED = 8'b00000010;
         default: LED = 8'b00000001;
      endcase


    assign DEBUG_A = PS2_CLK1;
    assign DEBUG_B = PS2_DATA1;

endmodule


// module Top (
//     input  CLK50MHZ,
//     input  RST,
//     // keyboard
//     inout  PS2_CLK1,
//     inout  PS2_DATA1,
//     // user interface
//     input  BTN_NORH,
//     input  BTN_PREV,
//     output [7:0] LED,
//     // debug
//     output DEBUG_A,
//     output DEBUG_B
// );

//    wire    ps2_clk_out;
//    wire    ps2_data_out;
//    wire [7:0] scancode;
//    wire scan_ready;
//    wire  cmd_trig;
//    wire [7:0] cmd;
//    PS2 ps2_ (
//         .clk(CLK50MHZ),
//         .rst(RST),
//         .ps2c(PS2_CLK1),
//         .ps2d(PS2_DATA1),
//         .scancode(scancode),
//         .scan_ready(scan_ready),
//         .cmd_trig(cmd_trig),
//         .cmd(cmd)
//     );

//    // wire  btn_kbd_rst;
//    // // TODO debouncers
//    // wire  btn_kbd_echo;

//     Controller controller_ (
//         .CLK50MHZ(CLK50MHZ),
//         .RST(RST),
//         .btn_kbd_rst(BTN_NORTH),
//         .btn_kbd_echo(BTN_PREV),
//         .cmd_trig(cmd_trig),
//         .cmd(cmd),
//         .scancode(scancode),
//         .scan_ready(scan_ready),
//         .led(LED)
//     );

//     assign DEBUG_A = PS2_CLK1;
//     assign DEBUG_B = PS2_DATA1;

// endmodule
