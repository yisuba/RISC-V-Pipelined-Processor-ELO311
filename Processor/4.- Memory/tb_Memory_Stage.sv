`timescale 1ns / 1ps

// tb_Memory_Stage
////// 
////// 
////////////////////////////

module tb_Memory_Stage;
	logic clk, rst;								
	logic RegWriteM, MemWriteM;
	logic [1:0] ResultSrcM;
	logic [4:0] RdM;				
	logic [31:0] ALUResultM, WriteDataM, PCPlus4M;
	logic [31:0] ReadDataM;
	
	Memory_Stage DUT(
		.clk(clk),
		.rst(rst),
		.RegWriteM(RegWriteM),
		.ResultSrcM(ResultSrcM),
		.MemWriteM(MemWriteM),
		.ALUResultM(ALUResultM),
		.WriteDataM(WriteDataM),
		.ReadDataM(ReadDataM),
		.RdM(RdM),
		.PCPlus4M(PCPlus4M)
	);
	
	always #5 clk = ~clk;
	
	initial begin
		RegWriteM = 0;
		ResultSrcM = 2'b00;
		RdM = 5'h3;
		PCPlus4M = 32'h28;
		
		clk = 0;
		rst = 1;
		MemWriteM = 0;
		ALUResultM = 32'h0;
		WriteDataM = 32'h0;
		
		#10 rst = 0; // Inicio de simulación (clk=0, rst=0)
		// Escritura de 32'h777 en 32'h3FC
		MemWriteM = 1;
		ALUResultM = 32'h3FC;
		WriteDataM = 32'h777;
		
		
		#10 //20ns
		// Escritura de 32'54321 en 32'h3F8
		MemWriteM = 1;
		ALUResultM = 32'h3F8;
		WriteDataM = 32'h54321;
		
		#10 //30ns
		// Lectura de 32'h3FC
		MemWriteM = 0;
		ALUResultM = 32'h3FC;
		
		#5 if(ReadDataM == 32'h777) $display ("1.1- Se completa la lectura de datos en %h. Data: %h", ALUResultM, ReadDataM);

		#5 //40ns
		// Lectura de 32'h3F8
		MemWriteM = 0;
		ALUResultM = 32'h3F8;

		#5 if(ReadDataM == 32'h54321) $display("1.2- Se completa la lectura de datos en %h. Data: %h", ALUResultM, ReadDataM);

		$finish;
	end
	
endmodule