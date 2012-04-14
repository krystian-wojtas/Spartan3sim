`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    09:48:08 03/13/2012 
// Design Name: 
// Module Name:    dacsim 
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

// LOGLEVEL = 0
// 	bez zadnych komunikatow
// LOGLEVEL = 1
// 	pokazuje bledy
// LOGLEVEL = 2
// 	pokazuje ostrzezenia
//
// LOGLEVEL = 3
// 	informuje o pomyslnych ustawieniach daca
// LOGLEVEL = 4
// 	informuje o stanach linii DAC_CLR i DAC_CS
// LOGLEVEL = 5
// 	informuje o adresie daca
// LOGLEVEL = 6 //TODO del
// 	debug
module dacLTC2624behav
#(
	parameter LOGLEVEL=5
) (
	input SPI_SCK,
	input DAC_CS,
	input DAC_CLR,
	input SPI_MOSI,
	output DAC_OUT
);
	 
	reg reseting = 1'b0;
	always @(negedge DAC_CLR) begin
		reseting = 1'b1;
		if(LOGLEVEL >= 4)
			$display("%t INFO4 resetowanie dac", $time);
	end
		
	reg reseted = 1'b0;
	always @(posedge DAC_CLR)
		if(reseting) begin
			reseted = 1'b1;
			if(LOGLEVEL >= 4)
				$display("%t INFO4 zresetowano dac", $time);
			if(LOGLEVEL >= 1)
				if(~DAC_CS)
					$display("%t BLAD Bezposrednio po zresetowaniu ukladu linia DAC_CS powinna byc w stanie wysokim.", $time); //TODO po ilu cyklach mozna wysylac dane?
		end
	
	
	reg [31:0] indacshiftreg;	
	wire [11:0] data = indacshiftreg[15:4];
	wire [3:0] address = indacshiftreg[19:16];
	wire [3:0] command = indacshiftreg[23:20];
	reg [5:0] indacshiftregidx;
			
	always @(negedge DAC_CS or negedge DAC_CLR or negedge SPI_SCK) begin
		if(~DAC_CLR) begin
			indacshiftreg <= 32'd0;
			indacshiftregidx <= 6'd0;
			if(LOGLEVEL >= 6)
				$display("%t DEBUG resetem wyzerowano index i shiftreg", $time);
		end else
			if(DAC_CS) begin
				indacshiftregidx <= 6'd0;
				if(LOGLEVEL >= 6)
					$display("%t DEBUG wyzerowano index", $time);
			end else begin
				indacshiftreg <= { indacshiftreg[30:0], SPI_MOSI };
				indacshiftregidx <= indacshiftregidx + 1;
			end
	end
	
	wire received32bits = (indacshiftregidx == 33);
	
	
	always @(negedge DAC_CS) begin
		if(LOGLEVEL >= 4)
			$display("%t INFO4 Odbieranie danych", $time);
		if(~reseted)
			if(LOGLEVEL >= 1)
				$display("%t BLAD Nastepuje proba przesylnia danych, bez uprzedniego zresetowania ukladu", $time);			
	end
	
	always @(posedge DAC_CS)
		if(reseted)
			if(~received32bits) begin
				if(LOGLEVEL >= 1)			
					$display("%t BLAD Do daca wyslanych zostalo %d bitow. Nalezy wyslac 32", $time, indacshiftregidx-1);
			end else begin
				if(LOGLEVEL >= 4)
					$display("%t INFO4 Zakonczenie odbioru danych", $time);
				if(LOGLEVEL >= 3)
					$display("%t INFO3 ustawiono\tliczbe %d (0x%h)\tna dacu nr %d (0x%h)\tz komenda %d (0x%h)", $time, data, data, address, address, command, command);
				
				case(address)
					4'b0000:	if(LOGLEVEL >= 5) $display("%t INFO5 dac nr %b (0x%h) - ustawi dac A", $time, address, address);
					4'b0001:	if(LOGLEVEL >= 5) $display("%t INFO5 dac nr %b (0x%h) - ustawi dac B", $time, address, address);
					4'b0010:	if(LOGLEVEL >= 5) $display("%t INFO5 dac nr %b (0x%h) - ustawi dac C (mozliwe ustawienie wzmocnienia)", $time, address, address);
					4'b0011:	if(LOGLEVEL >= 5) $display("%t INFO5 dac nr %b (0x%h) - ustawi dac D (mozliwe ustawienie wzmocnienia)", $time, address, address);
					4'b1111:	if(LOGLEVEL >= 5) $display("%t INFO5 dac nr %b (0x%h) - ustawi wszystkie dac'i", $time, address, address);
					default: if(LOGLEVEL >= 1) $display("%t BLAD niprawidlowy numer daca", $time);
				endcase
				
				if(command != 4'b0011)
					if(LOGLEVEL >= 1)			
						$display("%t BLAD nieprawidlowa komenda %b (0x%h) - aby natychmiastowo ustwic dac nalezy wyslac 0011 (0x3)", $time, command, command);
			end


	assign DAC_OUT = DAC_CS ? 1'b0 : indacshiftreg[31];
endmodule
