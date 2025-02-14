
// Etapa de Memory 
////// Aparentemente las señales están todas correctas
////////////////////////////

module Memory_Stage(
	input logic clk, rst,									
	input logic RegWriteM, MemWriteM,
	input logic [1:0] ResultSrcM,
	input logic [4:0] RdM,				
	input logic [31:0] ALUResultM, WriteDataM, PCPlus4M,
	output logic [31:0] ReadDataM
);

	Data_Memory DataMem(
		.clk(clk),
		.rst(rst),							
		.WriteEnable(MemWriteM),
		.Address(ALUResultM),
		.WriteData(WriteDataM),
		.ReadData(ReadDataM)
	);
	
endmodule