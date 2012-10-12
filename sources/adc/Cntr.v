`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:19:04 07/22/2012 
// Design Name: 
// Module Name:    Cntr 
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
module cntr(
	input CLK50MHZ,
	input RST,
	// amp
	output amp_trig,
	output [3:0] amp_a,
	output [3:0] amp_b,
	input amp_done,
	// adc
	output adc_trig,
	input adc_done,
	input [13:0] adc_a,
	input [13:0] adc_b,
	// control
	input [3:0] sw,
	output [7:0] led,
	input [7:0] amp_datareceived
    );	
	
	assign amp_a = 4'b0001; // 0.4 2.9
	assign amp_b = 4'b0010; // 1.025 2.275
	
	//frequency
	wire [31:0] cnt_max = 100_000_000; //TODO zaleznie czy symulacja czy synteza
//	wire [31:0] cnt_max = 300;	//TODO log2
	wire cnt_en;
	Counter Counter_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// counter
		.cnt_en(cnt_en),
		.cnt_max(cnt_max),
		.cnt_trig(adc_trig)
	);
	
	
	localparam [1:0]	RESTART = 2'd0,
							AMP_SENDING = 2'd1,
							ADC_CONVERTING = 2'd2;

	reg [1:0] state = RESTART;
	always @(posedge CLK50MHZ)
		if(RST)
			state <= RESTART;
		else
			case(state)
				RESTART:
					state <= AMP_SENDING;
				AMP_SENDING:
					if(amp_done)
						state <= ADC_CONVERTING;
				//ADC_CONVERTING:
					// stay here until reset
			endcase
	
	reg [7:0] ledreg;
	always @(posedge CLK50MHZ)
		if(RST)
			ledreg = 8'haa;
		else if(adc_done)
			case(sw)
				4'h1:		ledreg = adc_a[7:0];
				4'h2:		ledreg = adc_a[13:8];
				4'h4:		ledreg = adc_b[7:0];
				4'h8:		ledreg = adc_b[13:8];
				4'h3:		ledreg = amp_datareceived;
				default:	ledreg = 8'h55;
			endcase
	assign led = ledreg;
			
	
	assign amp_trig = (state == RESTART);
	assign cnt_en = (state == ADC_CONVERTING);

endmodule
