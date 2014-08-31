module Top
(
   input clk,
   input rst,
   output [7:0] outport
);

reg [7:0]   ACC = 8'd0;
reg [11:0]  PC = 12'd0;
reg [11:0]  PCtmp = 12'd0;
reg [15:0]  IR = 16'd0;
wire [3:0]  OPCODE = IR[15:12];;
wire [7:0]  OP1 = IR[7:0];
wire [11:0] ADDR = IR[11:0];
wire [11:0] addr2 = { 1'b0, ADDR[11:1] };

reg [15:0] PROM [0:3];
initial $readmemb("out.bindump", PROM);
reg [7:0] RAM [0:31];
initial RAM[0] = 8'd0;
assign outport = RAM[0][7:0];

always @(posedge clk)
   if(rst) PC <= 12'hfff;
   else begin
      PC <= PCtmp;
      IR <= PROM[PCtmp];
   end

always @*
   case(OPCODE)
      4'b1011: PCtmp = addr2;
      4'b1100: if(ACC == 7'd0) PCtmp = addr2; else PCtmp = PC + 1;
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
