module Controller(
	input RST,
	input CLK50MHZ,
	// verilog module interface
	//input spi_sck_trig, //TODO ?
	output reg [11:0] data = 0,
	output [3:0] address,
	output [3:0] command,
	output reg dactrig = 0,
	input dacdone,
	input [31:0] dac_datareceived,
	// control
	input less,
	input more,
	input [3:0] SW,
	// debug
	output [7:0] LED
    );

	assign address = 4'b1111;
	assign command = 4'b0011;
	reg [7:0] data_debug = 8'h55;

	reg [7:0] dac_datareceived_r = 0;


	assign LED = (SW) ? dac_datareceived_r : data_debug;
//	assign data = {4'h0, datareg}; //TODO 4'b1 ?
//	assign data = 12'hffe;
//	assign data = 12'h3ff;

	localparam STEP = 32;
	localparam MAXV = {12{1'b1}};

	always @(posedge CLK50MHZ)
		if(RST) begin
			data <= 12'h000;
			data_debug <= 8'h00;
			dac_datareceived_r <= 0;
		end else
			case(SW)
				4'h8: begin
					dac_datareceived_r <= dac_datareceived[31:24];
				end
				4'h4: begin
					dac_datareceived_r <= dac_datareceived[23:16];
				end
				4'h2: begin
					dac_datareceived_r <= dac_datareceived[15:8];
				end
				4'h1: begin
					dac_datareceived_r <= dac_datareceived[7:0];
				end
				default: begin
					if(less)
						if(data-STEP > 0) begin
							data <= data-STEP;
							data_debug <= data_debug - 1;
						end else begin
							data <= 0;
						end
					else if(more)
						if(data+STEP<MAXV) begin
							data <= data+STEP;
							data_debug <= data_debug + 1;
						end else begin
							data <= MAXV;
						end
				end
			endcase


	always @(posedge CLK50MHZ)
		if(RST) dactrig <= 1'b0;
		else
			if(less | more)
				dactrig <= 1'b1;
			else
				dactrig <= 1'b0;

endmodule
