`timescale 1ns / 1ps
`include "ALU_modded.sv"

// Etapa de Execute 
////// Falta verificar Adder
////// Falta integrar y entender las señales de Hazard Unit, actualmente solo están declaradas
////////////////////////////

module Execute_Stage(
	input logic JumpE, BranchE, ALUSrcE,
	input logic [1:0] ForwardAE, ForwardBE,
	input logic [3:0] ALUControlE,						
	input logic [31:0] PCE, ExtImmE, RD1E, RD2E,
	input logic [31:0] ALUResultM, ResultW,
	inout logic RegWriteE, MemWriteE,
	inout logic [1:0] ResultSrcE,
	inout logic [4:0] Rs1E, Rs2E, RdE,
	inout logic [31:0] PCPlus4E,		
	output logic [31:0] ALUResultE, WriteDataE,			
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
		endcase 
	end

	always_comb begin
		case(ForwardBE)									//MUX que elige segundo operando para ALU
			2'b00: WriteDataE = RD2E;
			2'b01: WriteDataE = ResultW;
			2'b10: WriteDataE = ALUResultM;
		    default:  WriteDataE = 32'b0;
		endcase
	end
	
	logic [31:0] SrcBE;
	always_comb begin									//MUX que elige si se usa imm para ALU
		case(ALUSrcE)
			1'b0: SrcBE = WriteDataE;
			1'b1: SrcBE = ExtImmE;
		endcase 
	end
	
	logic ZeroE;
	ALU_modded ALU(										// instancia ALU
		.A(SrcAE),
		.B(SrcBE),
		.OpCode(ALUControlE),
		.Result(ALUResultE),
		.Zero(ZeroE)
	);
	
	assign PCSrcE = (ZeroE && BranchE) || JumpE;
	
	assign PCTargetE = PCE + ExtImmE;	 				//verificar Adder
	
endmodule