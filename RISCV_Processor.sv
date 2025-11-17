`timescale 1ns / 1ps

// Procesador RISC-v
////// Falta FF entre decode-execute, execute-memory, memory-writeback
////// Falta instanciar stages execute, memory, writeback
////////////////////////////

module RISCV_Processor(
    input logic clk, rst
);
	logic PCSrcE, StallF, ALUSrcE;
    logic [31:0] PCTargetE, PCPlus4F, PCF_postff, InstrF;
    
    logic RegWriteW, RegWriteD, MemWriteD, JumpD, BranchD, AluSrcD, JalrD;
	logic [1:0] ResultSrcD, StoreTypeD;
	logic [2:0] LoadTypeD, BranchTypeD;
	logic [3:0] ALUControlD;
	logic [4:0] RdW, Rs1D, Rs2D, RdD;
	logic [31:0] InstrD, RD1D, RD2D, ResultW, PCD, PCPlus4D, ExtImmD;
    
	logic JumpE, BranchE, RegWriteE, MemWriteE, JalrE;
	logic [1:0] ResultSrcE, StoreTypeE, ForwardAE, ForwardBE;
	logic [2:0] LoadTypeE, BranchTypeE;
	logic [3:0] ALUControlE;				
	logic [4:0] Rs1E, Rs2E, RdE;	
	logic [31:0] PCE, ExtImmE, RD1E, RD2E, ALUResultM, PCPlus4E, ALUResultE, WriteDataE;

	logic RegWriteM, MemWriteM;
	logic [1:0] ResultSrcM, StoreTypeM;
	logic [2:0] LoadTypeM;
	logic [4:0] RdM;
	logic [31:0] WriteDataM, ReadDataM, PCPlus4M;
	
	logic [1:0] ResultSrcW;
	logic [2:0] LoadTypeW;
	logic [31:0] ALUResultW, ReadDataW, PCPlus4W;

    Fetch_Stage Fetch(
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .StallF(StallF),
        .PCTargetE(PCTargetE),
        .PCPlus4F(PCPlus4F),
        .PCF_postff(PCF_postff),
        .InstrF(InstrF)
    );	
	
	logic FlushD;
    always_ff @(posedge clk or posedge rst) begin			// FF de salida de la Fetch_Stage
        if(rst || FlushD) begin
            InstrD <= 32'b0;
            PCD <= 32'b0;
            PCPlus4D <= 32'b0;
        end
        else if(!StallD) begin
            InstrD <= InstrF;
            PCD <= PCF_postff;
            PCPlus4D <= PCPlus4F;
        end
    end
	
    Decode_Stage Decode(
        .clk(clk),
        .rst(rst),
        .InstrD(InstrD),
        .PCD(PCD),
        .PCPlus4D(PCPlus4D),
        .RdW(RdW),
        .ResultW(ResultW),
        .RegWriteW(RegWriteW),
        .RD1D(RD1D),
        .RD2D(RD2D),
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .RdD(RdD),
        .ExtImmD(ExtImmD),
        .RegWriteD(RegWriteD),
        .MemWriteD(MemWriteD),
        .JumpD(JumpD),
        .BranchD(BranchD),
        .AluSrcD(AluSrcD),
        .ResultSrcD(ResultSrcD),
        .LoadTypeD(LoadTypeD),
        .StoreTypeD(StoreTypeD),
        .BranchTypeD(BranchTypeD),
		.JalrD(JalrD),
        .ALUControlD(ALUControlD)
    );

    logic FlushE;
    always_ff @(posedge clk or posedge rst) begin			// FF de salida de la Decode_Stage
        if(rst || FlushE) begin
            RegWriteE <= 1'b0;
            ResultSrcE <= 2'b0;
            LoadTypeE <= 3'b0;
			StoreTypeE <= 2'b0;
			BranchTypeE <= 3'h2;
			JalrE <= 1'b0;
            MemWriteE <= 1'b0;
			JumpE <= 1'b0;
			BranchE <= 1'b0;
			ALUControlE <= 3'b0;
			ALUSrcE <= 1'b0;
			RD1E <= 32'b0;
			RD2E <= 32'b0;
			PCE <= 32'b0;
			Rs1E <= 5'b0;
			Rs2E<= 5'b0;
			RdE <= 5'b0;
			ExtImmE <= 32'b0;
			PCPlus4E <= 32'b0;
        end
		else begin
			RegWriteE <= RegWriteD;
			ResultSrcE <= ResultSrcD;
			LoadTypeE <= LoadTypeD;
			StoreTypeE <= StoreTypeD;
			BranchTypeE <= BranchTypeD;
			JalrE <= JalrD;
			MemWriteE <= MemWriteD;
			JumpE <= JumpD;
			BranchE <= BranchD;
			ALUControlE <= ALUControlD;
			ALUSrcE <= AluSrcD;
			RD1E <= RD1D;
			RD2E <= RD2D;
			PCE <= PCD;
			Rs1E <= Rs1D;
			Rs2E <= Rs2D;
			RdE <= RdD;
			ExtImmE <= ExtImmD;
			PCPlus4E <= PCPlus4D;
		end
    end

	Execute_Stage Execute(
        .JumpE(JumpE),
        .BranchE(BranchE),
        .ALUSrcE(ALUSrcE),
        .ALUControlE(ALUControlE),
        .PCE(PCE),
        .ExtImmE(ExtImmE),
        .RD1E(RD1E),
        .RD2E(RD2E),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .ALUResultM(ALUResultM),
        .ResultW(ResultW),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE),
        .RegWriteE(RegWriteE),
        .MemWriteE(MemWriteE),
        .ResultSrcE(ResultSrcE),
        .LoadTypeE(LoadTypeE),
        .StoreTypeE(StoreTypeE),
        .BranchTypeE(BranchTypeE),
		.JalrE(JalrE),
        .RdE(RdE),
        .PCPlus4E(PCPlus4E),
        .ALUResultE(ALUResultE),
        .WriteDataE(WriteDataE),
        .PCTargetE(PCTargetE),
        .PCSrcE(PCSrcE)
	);
	
    always_ff @(posedge clk or posedge rst) begin			// FF de salida de la Execute_Stage
        if(rst) begin
            RegWriteM <= 1'b0;
            ResultSrcM <= 2'b0;
            LoadTypeM <= 1'b0;
            StoreTypeM <= 2'b0;
            MemWriteM <= 1'b0;
			ALUResultM <= 32'b0;
			WriteDataM <= 32'b0;
			RdM <= 5'b0;
			PCPlus4M <= 32'b0;
        end
        else begin
            RegWriteM <= RegWriteE;
            ResultSrcM <= ResultSrcE;
            LoadTypeM <= LoadTypeE;
            StoreTypeM <= StoreTypeE;
            MemWriteM <= MemWriteE;
			ALUResultM <= ALUResultE;
			WriteDataM <= WriteDataE;
			RdM <= RdE;
			PCPlus4M <= PCPlus4E;
        end
    end
	
	Memory_Stage Memory(
        .clk(clk),
        .rst(rst),
        .RegWriteM(RegWriteM),
        .ResultSrcM(ResultSrcM),
        .LoadTypeM(LoadTypeM),
        .StoreTypeM(StoreTypeM),
        .MemWriteM(MemWriteM),
        .ALUResultM(ALUResultM),
        .WriteDataM(WriteDataM),
        .ReadDataM(ReadDataM),
        .RdM(RdM),
        .PCPlus4M(PCPlus4M)
	);
	
    always_ff @(posedge clk or posedge rst) begin			// FF de salida de la Memory_Stage
        if(rst) begin
            RegWriteW <= 1'b0;
            ResultSrcW <= 2'b0;
            LoadTypeW <= 3'b0;
			ALUResultW <= 32'b0;
			ReadDataW <= 32'b0;
            RdW <= 5'b0;
            PCPlus4W <= 32'b0;
        end
        else begin
            RegWriteW <= RegWriteM;
            ResultSrcW <= ResultSrcM;
            LoadTypeW <= LoadTypeM;
			ALUResultW <= ALUResultM;
			ReadDataW <= ReadDataM;
			RdW <= RdM;
			PCPlus4W <= PCPlus4M;
        end
    end	
	
	WriteBack_Stage WriteBack(
        .RegWriteW(RegWriteW),
        .ResultSrcW(ResultSrcW),
        .LoadTypeW(LoadTypeW),
        .ALUResultW(ALUResultW),
        .ReadDataW(ReadDataW),
        .PCPlus4W(PCPlus4W),
        .RdW(RdW),
        .ResultW(ResultW)
	);
	
	Hazard_Unit Hazards(
        .PCSrcE(PCSrcE),
        .RegWriteM(RegWriteM),
        .RegWriteW(RegWriteW),
        .ResultSrcE(ResultSrcE),
        .Rs1D(Rs1D),
        .Rs2D(Rs2D),
        .Rs1E(Rs1E),
        .Rs2E(Rs2E),
        .RdE(RdE),
        .RdM(RdM),
        .RdW(RdW),
        .StallF(StallF),
        .StallD(StallD),
        .FlushD(FlushD),
        .FlushE(FlushE),
        .ForwardAE(ForwardAE),
        .ForwardBE(ForwardBE)
	);
	
 endmodule   