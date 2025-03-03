`timescale 1ns / 1ps

// Etapa de Memory 
////// Aparentemente las señales están todas correctas
////////////////////////////

module Memory_Stage(
	input logic clk, rst,									
	input logic RegWriteM, MemWriteM,
	input logic [1:0] ResultSrcM, StoreTypeM,
	input logic [2:0] LoadTypeM,
	input logic [4:0] RdM,				
	input logic [31:0] ALUResultM, WriteDataM, PCPlus4M,
	
	output logic [31:0] ReadDataM
);
    
    logic [31:0] WriteDataM_processed;
    always_comb begin
        case(StoreTypeM)
            2'b00: WriteDataM_processed = {24'b0, WriteDataM[7:0]};  //sb
            2'b01: WriteDataM_processed = {16'b0, WriteDataM[15:0]}; //sh
            2'b10: WriteDataM_processed = WriteDataM;                //sw
            default: WriteDataM_processed = 32'bx;
        endcase
    end
    
	Data_Memory DataMem(
		.clk(clk),
		.rst(rst),							
		.WriteEnable(MemWriteM),
		.Address(ALUResultM),
		.WriteData(WriteDataM_processed),
		.ReadData(ReadDataM)
	);
	
endmodule