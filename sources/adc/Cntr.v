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
	
	assign amp_a = 4'b0000; // 0.4 2.9
//	assign amp_b = 4'b0010; // 1.025 2.275
	assign amp_b = 4'b1100; //  0.4 2.9 ??
	
	reg cnt_en;
	wire cnt_tick;
	assign adc_trig = cnt_tick;
	Counter #(
		.MAX(100_000_000)
//		.MAX(300)
	)	Counter_(
		.CLKB(CLK50MHZ),
		.rst(RST),
		// counter
		.en(cnt_en),
		.sig(1'b1),
		.full(cnt_tick)
	);
	
	
	localparam [2:0]	RESTART = 3'd0,
							AMP_SENDING = 3'd1,
							ADC_CONVERT = 3'd2,
							ADC_CONVERTING = 3'd3,
							CNT_START = 3'd4,
							CNT_WAIT = 3'd5; //TODO order

	reg [2:0] state = RESTART;
	always @(posedge CLK50MHZ)
		if(RST)
			state <= RESTART;
		else
			case(state)
				RESTART:
					state <= AMP_SENDING;
				AMP_SENDING:
					if(amp_done)
						state <= CNT_START;
				CNT_START:
					state <= CNT_WAIT;
				CNT_WAIT:
					if(cnt_tick)
						state <= ADC_CONVERT;
				ADC_CONVERT:
					state <= ADC_CONVERTING;
				ADC_CONVERTING:
					if(adc_done)
						state <= RESTART;
			endcase
	
	always @(posedge CLK50MHZ)
		if(RST)
			cnt_en <= 1'b0;
		else
			case(state)
				CNT_START:
					cnt_en <= 1'b1;
				ADC_CONVERT:
					cnt_en <= 1'b0;
			endcase
	//TODO assign state == CNT_START or CNT_WAIT
	
	
	//TODO del
	reg timer;
	always @(posedge CLK50MHZ)
		if(RST)
			timer <= 1'b0;
		else
			if(cnt_tick)
				timer <= ~timer;
				
	
	reg [7:0] ledreg;
	always @(posedge CLK50MHZ)
		if(RST)
			ledreg <= 8'haa;
		else if(adc_done)
			case(sw)
				4'h1:		ledreg <= adc_a[7:0];
				4'h2:		ledreg <= adc_a[13:8];
				4'h4:		ledreg <= adc_b[7:0];
				4'h8:		ledreg <= adc_b[13:8];
				4'h3:		ledreg <= amp_datareceived;
				default:	ledreg <= { 7'h55, timer };
			endcase
	assign led = ledreg;
			
	
	assign amp_trig = (state == RESTART);
	//assign cnt_en = (state == ADC_CONVERTING);
	

endmodule
