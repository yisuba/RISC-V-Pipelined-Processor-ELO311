`timescale 1ns / 1ps

// Etapa de Execute 
////// Falta verificar Adder
////// Falta integrar y entender las señales de Hazard Unit, actualmente solo están declaradas
////////////////////////////

module Execute_Stage(
	input logic JumpE, BranchE, ALUSrcE, JalrE,
	input logic [1:0] ForwardAE, ForwardBE,
	input logic [3:0] ALUControlE,
	input logic [31:0] PCE, ExtImmE, RD1E, RD2E,
	input logic [31:0] ALUResultM, ResultW,
	
	input logic RegWriteE, MemWriteE,
	input logic [1:0] ResultSrcE, StoreTypeE,
	input logic [2:0] LoadTypeE, BranchTypeE,
	input logic [4:0] Rs1E, Rs2E, RdE,
	input logic [31:0] PCPlus4E,		

	output logic [31:0] ALUResultE, WriteDataE,
	output logic [31:0] PCTargetE,
	output logic PCSrcE
);
	
	logic BranchTakenE;
	logic [31:0] SrcAE, SrcBE, SrcAdderE;
	
	always_comb begin
	//MUX que elige primer operando para Adder (Caso jalr)
		case(JalrE)
			1'b0: SrcAdderE = PCE;
			1'b1: SrcAdderE = RD1E;
			default: SrcAdderE = 32'bx;
		endcase

	//MUX que elige primer operando para ALU	
		case(ForwardAE)								    
			2'b00: SrcAE = RD1E;
			2'b01: SrcAE = ResultW;
			2'b10: SrcAE = ALUResultM;
			default: SrcAE = 32'bx;
		endcase 
		
    //MUX que elige segundo operando para ALU
		case(ForwardBE)									
			2'b00: WriteDataE = RD2E;
			2'b01: WriteDataE = ResultW;
			2'b10: WriteDataE = ALUResultM;
		    default: WriteDataE = 32'bx;
		endcase
		
    //MUX que elige si se usa imm para ALU			
		case(ALUSrcE)			                       
			1'b0: SrcBE = WriteDataE;
			1'b1: SrcBE = ExtImmE;
			default: SrcBE = 32'bx;
		endcase
		
		PCSrcE = (BranchTakenE && BranchE) || JumpE; 		//BranchTaken es un simil de ZeroE del esquema de microarquitectura
		PCTargetE = SrcAdderE + ExtImmE;	 				//verificar Adder
	end
	
	//Instancia ALU
	ALU_Modded ALU(										
		.A(SrcAE),
		.B(SrcBE),
		.BranchType(BranchTypeE),
		.OpCode(ALUControlE),
		.Result(ALUResultE),
		.BranchTaken(BranchTakenE)
	);
	
endmodule