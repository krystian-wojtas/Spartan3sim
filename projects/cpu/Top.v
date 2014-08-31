module Top
(
   input clk,
   input rst,
   output [7:0] outport
);

reg [7:0] ACC = 8'd0;
reg [11:0] PC = 12'd0;
reg [11:0] PCtmp = 12'd0;
reg [15:0] IR = 16'd0;
   wire [3:0] OPCODE;
   wire [11:0] ADDR;
   wire [7:0]  OP1;
assign OPCODE=IR[15:12];
assign ADDR=IR[11:0];
assign OP1 = IR[7:0];

reg [15:0] PROM [0:4];
// initial $readmemh("out.hex", PROM);
initial begin
   PROM[0] = 16'h0000;
   PROM[1] = 16'h0033;
   PROM[2] = 16'h2000;
   PROM[3] = 16'h9000;
   PROM[4] = 16'hb002;
end
reg [7:0] RAM [0:31];
initial begin
   RAM[0] = 8'd0;
end
assign outport = RAM[0][7:0];

always @(posedge clk)
   if(rst) PC <= 11'd0;
   else begin
      PC <= PCtmp;
      IR <= PROM[PCtmp];
   end

always @*
   case(OPCODE)
      4'b1011: PCtmp=ADDR;
      4'b1100: if(ACC == 7'd0) PCtmp = ADDR; else PCtmp = PC + 1;
      default: PCtmp = PC + 1;
   endcase

always @(posedge clk)
   case(OPCODE)

      // Load immediate value
      4'b0000: ACC <= OP1;

      // Load from / store to RAM
      4'b0001: ACC <= RAM[ADDR];
      4'b0010: RAM[ADDR] <= ACC;

      // ALU
      4'b0011: ACC <= ACC + OP1;
      4'b0100: ACC <= ACC - OP1;
      4'b0101: ACC <= ACC & OP1;
      4'b0110: ACC <= ACC | OP1;
      4'b0111: ACC <= ACC ^ OP1;
      4'b1000: ACC <= ~ ACC;
      4'b1001: ACC <= { ACC[6:0], ACC[7] };
      4'b1100: ACC <= { ACC[0], ACC[7:1] };
   endcase

endmodule
