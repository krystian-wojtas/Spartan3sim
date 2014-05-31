module DacSpi (
	input RST,
	input CLK50MHZ,
	// hardware dac interface
	output SPI_SCK,
	output DAC_CLR,
	output DAC_CS,
	output SPI_MOSI,
	input	DAC_OUT,
	// verilog module interface
	input [11:0] data,
	input [3:0] address,
	input [3:0] command,
	output [31:0] dac_datareceived,
	input dactrig,
	output dacdone
	);

	localparam WIDTH=32;

	wire tick_neg;
	wire spi_sck;
	ModClk #(
		.DIV(2)
	) ModClk_(
		.CLK50MHZ(CLK50MHZ),
		.rst(dactrig),
		.clk_hf(spi_sck), //half filled 50%
		.neg_trig(tick_neg)
	);

	wire [WIDTH-1:0] dacdatatosend = {8'h80, command, address, data, 4'h1};
	Spi #(
		.WIDTH(WIDTH)
	) Spi_ (
		.CLKB(CLK50MHZ),
		.RST(RST),
		// spi lines
		.spi_cs(DAC_CS),
		.spi_mosi(SPI_MOSI),
		.spi_miso(DAC_OUT),
		// spi module interface
		.data_in(dacdatatosend),
		.data_out(dac_datareceived),
		.trig(dactrig),
		.ready(dacdone),
		.clk(CLK50MHZ),
		.tick(tick_neg)
	);

	assign SPI_SCK = (~dacdone) ? spi_sck : 1'b0;
	assign DAC_CLR = ~RST;

endmodule
