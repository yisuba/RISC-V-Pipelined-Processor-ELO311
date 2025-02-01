`timescale 1ns / 1ps
`include "Data_Memory.sv"

// Etapa de Memory 
////// Falta Realizar Data_Memomy
////// Aparentemente las señales están todas correctas
////////////////////////////

module Memory_Stage(
	input clk, rst,									//verificar si es necesario el rst
	inout logic RegWriteM,
	inout logic [1:0] ResultSrcM,
	input logic MemWriteM,							//Fin control signals
	inout logic [31:0] ALUResultM, 
	input logic [31:0] WriteDataM,
	output logic [31:0] ReadDataM,
	inout logic [4:0] RdM,
	inout logic [31:0] PCPlus4M
);

	Data_Memory DataMem(
		.clk(clk),
		.rst(rst),									//verificar si es necesario el rst
		.WE(MemWriteM),
		.WD(WriteDataM),
		.A(ALUResultM),
		.RD(ReadDataM)
	);
	
endmodule