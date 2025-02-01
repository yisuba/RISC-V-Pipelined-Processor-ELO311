`timescale 1ns / 1ps

// Etapa de WriteBack 
////// Falta verificar funcionamiento del stage
////// Aparentemente las señales están todas correctas
////////////////////////////

module WriteBack_Stage(
	input logic clk, rst,						//verificar si es necesario el rst
	inout logic RegWriteW,
	input logic [1:0] ResultSrcW,
	input logic [31:0] ALUResultW, ReadDataW, PCPlus4W,
	inout logic [4:0] RdW,
	output logic [31:0] ResultW
);

	always_comb begin							//MUX para seleccionar ResultW
		case(ResultSrcW)
			2'b00: ResultW = ALUResultW;
			2'b01: ResultW =  ReadDataW;
			2'b10: ResultW = PCPlus4W;
			default: ResultW = 32'b0;
		endcase
	end
	
endmodule