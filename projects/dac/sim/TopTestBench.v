module TopTestBench(
	input CLK50MHZ,
	input RST,
	output reg BTN_WEST,
	output reg BTN_EAST,
	output reg [3:0] SW
    );

	initial begin
		SW = 4'h0;
		BTN_WEST = 1'b0;
		BTN_EAST = 1'b0;

		@(negedge RST);
		#300;

		BTN_EAST = 1'b1;
		#250;
		BTN_EAST = 1'b0;


		#3800;
		BTN_EAST = 1'b1;
		#250;
		BTN_EAST = 1'b0;


		#3800;
		SW = 4'h1;
		#2000;
		SW = 4'h0;

		#1500;
	end

endmodule
