`include "Control_Unit.sv"
`include "Register_File.sv"
`include "Extend.sv"


// Instruction_Decode_Stage
////// Falta Control_Unit + Register_File + Extend
////// Falta realizar Testbench
////////////////////////////

module Instruction_Decode_Stage(
	input logic clk, rst,
	input logic [31:0] InstrD, PCD, PCPlus4D,
	input logic [4:0] RdW, ResultW,						//Revisar bus de bits de ResultW
	input logic RegWriteW,
	output logic [4:0] RD1D, RD2D, Rs1D, Rs2D, RdD,
	output logic [24:0] ExtImmD,
	output logic RegWriteD, MemWriteD, JumpD, BranchD, AluSrcD,		//Control Unit signals
	output logic [1:0] ResultSrcD,
	output logic [3:0] ALUControlD		//Modificado a [3:0] para adecuarse al RV32I
);


	Control_Unit CtrlUnit(				//instancia de ControlUnit
	.InstrD(InstrD),
	.RegWriteD(RegWriteD),
	.ResultSrcD(ResultSrcD),
	.MemWriteD(MemWriteD),
	.JumpD(JumpD),
	.BranchD(BranchD),
	.ALUControlD(ALUControlD),
	.AluSrcD(AluSrcD),
	.ImmSrcD(ImmSrcD)
	);


	logic [4:0] A1, A2;
	assign A1 = InstrD[19:15];
	assign A2 = InstrD[24:20];
	Register_File RegFile(				//instancia de RegisterFile
	.clk(clk),
	.rst(rst),
	.WE3(RegWriteW),
	.A1(A1),
	.A2(A2),
	.A3(RdW),
	.WD3(ResultW),
	.RD1D(RD1D),
	.RD2D(RD2D)
	);
	
	assign Rs1D = InstrD[19:15];		//Cables 
	assign Rs2D = InstrD[24:20];
	assign RdD = InstrD[11:7];
	
	
	logic [24:0] Extend_in;
	logic [1:0] ImmSrcD;
	Extend ExtImm(		
	.InstrD(InstrD),				//instancia del Extend/Immediate
	.ImmSrcD(ImmSrcD),
	.ExtImmD(ExtImmD)
	);
	
endmodule