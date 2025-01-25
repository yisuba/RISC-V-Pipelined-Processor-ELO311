`include "Fetch_Stage.sv"
`include "Decode_Stage.sv"
`include "Execute_Stage.sv"
`include "Memory_Stage.sv"
`include "WriteBack_Stage.sv"

// Procesador RISC-v
////// Falta FF entre decode-execute, execute-memory, memory-writeback
////// Falta instanciar stages execute, memory, writeback
////////////////////////////

module RISC_V_Processor(
    input logic clk, rst
);

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
    
    logic [31:0] InstrD, PCD, PCPlus4D;
    logic StallD;
    always_ff @(posedge clk or posedge rst) begin			// FF de salida de la Instruction_Fetch
        if(rst) begin
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
        .ALUControlD(ALUControlD)
    );
   /* 
    logic FlushE;
    always_ff @(posedge clk or posedge rst) begin			// FF de salida de la Instruction_Fetch
        if(rst) begin
            InstrD <= 32'b0;
            PCD <= 32'b0;
            PCPlus4D <= 32'b0;
            end
        else if(!StallD) begin
            InstrD <= InstrF;
            PCD <= PCF_postff;
            PCPlus4D <= PCPlus4F;
            end
    end*/
	
	Execute_Stage Execute(
	
	);
	
	Memory_Stage Memory(
	
	);
	
	WriteBack_Stage WriteBac(
	
	);
	
 endmodule   

/////////////////////////////////////////////////////////////////////////
	/*input logic clk, rst,
    input logic PCSrcE,
    input logic [31:0] PCTargetE,
    inout logic [31:0] PCPlus4F,
    output logic [31:0] PCF_postff*/
	

