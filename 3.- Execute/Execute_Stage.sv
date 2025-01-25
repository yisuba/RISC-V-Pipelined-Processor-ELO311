`timescale 1ns / 1ps
`include "ALU_modded.sv"

// Etapa de Execute 
////// Falta verificar Adder
////// Falta integrar y entender las señales de Hazard Unit, actualmente solo están declaradas
////////////////////////////

module Execute_Stage(
	inout logic RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE,
	inout logic [1:0] ResultSrcE,
	input logic [2:0] ALUControlE,						//Fin señales de control
	input logic [4:0] RD1E, RD2E, Rs1E, Rs2E, RdE,
	input logic [31:0] PCE, ExtImmE, PCPlus4E,		
	output logic [31:0] ALUResultE, WriteDataE,			//Fin señales de y hacia FF
	input logic [31:0] ALUResultM, ResultW,
	output logic [31:0] PCTargetE,
	output logic PCSrcE
);
	
	logic [31:0] SrcAE;
	always_comb begin									//MUX que elige primer operando para ALU
		case(ForwardAE)
			2'b00: SrcAE = RD1E;
			2'b01: SrcAE = ResultW;
			2'b10: SrcAE = ALUResultM;
			default: SrcAE = 32'b0;
	end

	always_comb begin
		case(ForwardBE)									//MUX que elige segundo operando para ALU
			2'b00: WriteDataE = RD2E;
			2'b01: WriteDataE = ResultW;
			2'b10: WriteDataE = ALUResultM;
		default: 32'b0;
	end
	
	logic [31:0] SrcBE;
	always_comb begin									//MUX que elige si se usa imm para ALU
		case(ALUSrcE)
			1'b0: SrcBE = WriteDataE;
			1'b1: SrcBE = ExtImmE;
	end
	
	ALU_modded ALU(										// instancia ALU
		.A(SrcAE),
		.B(SrcBE),
		.OpCode(ALUControlE),
		.Result(ALUResultE),
		.Zero(ZeroE),
	);
	
	logic aux;
	assign aux = ZeroE && BranchE; 						//verificar si se puede utilizar "and" o si es solo un &
	assign PCSrcE = aux || JumpE;
	
	assign PCTargetE = PCE + ExtImmE;	 				//verificar Adder
	
endmodule