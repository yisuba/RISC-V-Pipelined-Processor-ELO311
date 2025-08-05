`timescale 1ns / 1ps

// Decode_Stage
////// Falta Terminar Control_Unit
////////////////////////////

module Decode_Stage(
	input logic clk, rst,
	input logic [31:0] InstrD, ResultW, PCD, PCPlus4D,	
	input logic [4:0] RdW,						
	input logic RegWriteW,
	
	output logic [4:0] Rs1D, Rs2D, RdD,
	output logic [31:0] RD1D, RD2D, ExtImmD,
	
	output logic RegWriteD, MemWriteD, JumpD, BranchD, AluSrcD,	JalrD, //Control Unit signals
	output logic [1:0] ResultSrcD, StoreTypeD,
	output logic [2:0] LoadTypeD, BranchTypeD,	
	output logic [3:0] ALUControlD		               //Modificado a [3:0] para adecuarse al RV32I
);

	logic [2:0] ImmSrcD, funct3;
	logic [4:0] A1, A2;
	logic [6:0] opcode, funct7;			

    assign opcode = InstrD[6:0];
    assign funct3 = InstrD[14:12];
    assign funct7 = InstrD[31:25];
    assign A1 = InstrD[19:15];
    assign A2 = InstrD[24:20];
        
    assign Rs1D = InstrD[19:15];		
    assign RdD = InstrD[11:7];
    
    // para evitar que rs2d = immediate para las instrucciones I imm, I load, S, J, Jalr
    always_comb begin
	if(opcode == 7'b001_0011 || opcode == 7'b000_0011 || opcode == 7'b010_0011 || opcode == 7'b110_1111 || opcode == 7'b110_0111)
        Rs2D = 5'b0;
    else
        Rs2D = InstrD[24:20];
    end

	
	// instancia de ControlUnit
	Control_Unit CtrlUnit(				
        .op(opcode),
        .funct3(funct3),
        .funct7(funct7),
        .RegWriteD(RegWriteD),
        .ResultSrcD(ResultSrcD),
        .MemWriteD(MemWriteD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .ALUControlD(ALUControlD),
        .AluSrcD(AluSrcD),
        .ImmSrcD(ImmSrcD),
        .LoadTypeD(LoadTypeD),
        .StoreTypeD(StoreTypeD),
        .BranchTypeD(BranchTypeD),
		.JalrD(JalrD)
	);

    // instancia de RegisterFile
	Register_File RegFile(				
        .clk(clk),
        .rst(rst),							
        .WriteEnable(RegWriteW),
        .Register1(A1),
        .Register2(A2),
        .RegisterDestination(RdW),
        .WriteData(ResultW),
        .RegisterData1(RD1D),
        .RegisterData2(RD2D)
	);
	
	//instancia del Extend/Immediate
	Extend Ext(						
        .InstrD(InstrD),					
        .ImmSrcD(ImmSrcD),
        .ExtImmD(ExtImmD)
	);
	
endmodule