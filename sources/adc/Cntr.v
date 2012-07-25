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
	
	assign amp_a = 4'b1000;
	assign amp_b = 4'b0001;
	
	//frequency
	wire [31:0] cnt_max = 100_000_000; //TODO zaleznie czy symulacja czy synteza
	//wire [31:0] cnt_max = 50;	//TODO log2
	wire cnt_en;
	Counter Counter_(
		.CLK50MHZ(CLK50MHZ),
		.RST(RST),
		// counter
		.cnt_en(cnt_en),
		.cnt_max(cnt_max),
		.cnt_trig(adc_trig)
	);
	
	
	//localparam [2:0]	RESTART = 3'd0,
		//					AMP_SENDING = 3'd1,
			//				AMP_TRIG2 = 3'd2,
				//			AMP_RE = 3'd3,
					//		ADC_CONVERTING = 3'd4;
					

	//reg [2:0] state;
	//always @(posedge CLK50MHZ)
		//if(RST)
			//state <= RESTART;
		//else
			//case(state)
				//RESTART:
					//state <= AMP_SENDING;
//				AMP_SENDING:
	//				if(amp_done)
		//				state <= AMP_TRIG2;
						//state <= ADC_CONVERTING;
			//	AMP_TRIG2:
				//	state <= AMP_RE;
//				AMP_RE:
	//				if(amp_done)
						//state <= ADC_CONVERTING;
		//				state <= AMP_TRIG2;
				//ADC_CONVERTING:
					// stay here until reset
			//endcase
			
	
	localparam [2:0]	RESTART = 3'd0,
							AMP_SENDING = 3'd1,
							AMP_TRIG2 = 3'd2,
							AMP_RE = 3'd3,
							CNT_WAIT = 3'd4;
					
	wire cnt_trig2;
	reg [2:0] state;
	always @(posedge CLK50MHZ)
		if(RST)
			state <= RESTART;
		else
			case(state)
				RESTART:
					state <= AMP_SENDING;
				AMP_SENDING:
					if(amp_done)
						state <= CNT_WAIT;
				CNT_WAIT:
					if(cnt_trig2)
						state <= RESTART;
			endcase
					
	reg [31:0] counter = 0;
	wire cnt_en2 = (state == CNT_WAIT);
	always @(posedge CLK50MHZ)
		if(RST) counter <= 0;
		else
			if(cnt_en2) begin
				if(counter <= cnt_max)
					counter <= counter + 1;
				else
					counter <= 0;
			end else
				counter <= 0;
	assign cnt_trig2 = (counter == cnt_max);
	
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
			
	
	assign amp_trig = (state == RESTART || state == RESTART);
	//assign cnt_en = (state == ADC_CONVERTING);

endmodule
