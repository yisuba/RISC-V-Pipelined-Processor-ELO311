`include "Instruction_Fetch_Stage.sv"
`include "Instruction_Decode_Stage.sv"

module RISC_V_Processor(
    input logic clk, rst
);

    Instruction_Fetch_Stage IF(
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
    
    Instruction_Decode_Stage ID(
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
 endmodule   

/////////////////////////////////////////////////////////////////////////
	/*input logic clk, rst,
    input logic PCSrcE,
    input logic [31:0] PCTargetE,
    inout logic [31:0] PCPlus4F,
    output logic [31:0] PCF_postff*/
	

