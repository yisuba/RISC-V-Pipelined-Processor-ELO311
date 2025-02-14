`timescale 1ns / 1ps

// tb_Decode_Stage
////// Falta probar algunas señales como MemWriteD, ResultSrcD, JumpD, 
////// BranchD y otros valores de DUT.ImmSrcD.
////// Y otras instrucciones que utilicen diferente ImmSrcD y funct7
////////////////////////////

module tb_Decode_Stage;

	logic clk, rst;
	logic [31:0] InstrD, ResultW;
	logic [31:0] PCD, PCPlus4D;
	logic [4:0] RdW;						
	logic RegWriteW;
	logic [4:0] Rs1D, Rs2D, RdD;
	logic [31:0] RD1D, RD2D, ExtImmD;
	logic RegWriteD, MemWriteD, JumpD, BranchD, AluSrcD;
	logic [1:0] ResultSrcD;
	logic [3:0] ALUControlD;
	
    Decode_Stage DUT(
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
	
	always #5 clk = ~clk;
	
	initial begin
		clk = 1'b0;
		rst = 1'b1;
		InstrD = 32'b0000_0000_0010_0000_1000_0001_1001_0011; 	//32'h0020_8193 -> addi x3, x1, 2 -> addi gp, ra, 2	
		PCD = 32'h24;
		PCPlus4D = 32'h0000_0028;

		#10 //10ns **** Empieza la Simulación con valores inicializados
		rst = 0;
		RegWriteW = 1'b1;
		RdW = 5'h1;
		ResultW = 32'h7;		// 0x7 se escribe en x1 (negedge)
		
		#10 //20ns
		RdW = 5'h2;
		ResultW = 32'h5555;		// 0x5555 se escribe en x2 (negedge)
		
		#15 //35ns 
			// Desglose de InstrD (addi x3, x1, 2)
			if(DUT.InstrD[6:0] == 7'b001_0011) $display("1.1- opcode correcto, FMT: I. opcode: %h", DUT.InstrD[6:0]);
			if(DUT.InstrD[11:7] == 5'h3) $display("1.2- rd correcto, x3 (gb). rd: %h", DUT.InstrD[11:7]);
			if(DUT.InstrD[14:12] == 3'h0) $display("1.3- funct3 correcto, x0. funct3: %h", DUT.InstrD[14:12]);
			if(DUT.InstrD[19:15] == 5'h1) $display("1.4- rs1 correcto, x1 (ra). rs1: %h", DUT.InstrD[19:15]);
			//if(DUT.InstrD[24:20] == 5'h2) $display("1.4- rs2 correcto, x2 (gp). rs2: %h", DUT.InstrD[24:20]);
			//if(DUT.InstrD[31:25] == 6'h20) $display("1.5- funct7 correcto, 2. imm: %h", DUT.InstrD[31:20]);			
			if(DUT.InstrD[31:20] == 32'd2) $display("1.5- imm correcto, 2. imm: %h", DUT.InstrD[31:20]);
	
			// VerificaciÃ³n de paso de seÃ±ales Reg_File
			if (RD1D == 32'h7) $display("1.6- Register Data 1 cargado correctamente. Registro: %h", RD1D); 
			if (RD2D == 32'h5555) $display("1.7- Register Data 2 cargado correctamente. Registro: %h", RD2D);
			if (ExtImmD == 32'h2) $display("1.8- Inmediato extendido correctamente. Imm: %h", ExtImmD);
			if (RdD == 5'h3) $display("1.9- Registro de destino cargado correctamente. Registro: %h", RdD);
			if (RegWriteD == 1'b1) $display("1.10- SeÃ±al RegWriteD funcionando. RegWriteD: %h", RegWriteD);
			if (AluSrcD == 1'b1) $display("1.11- Señal AluSrcD funcionando. AluSrcD: %h", AluSrcD);
			if (ALUControlD == 4'b0000) $display("1.12- Señal ALUControlD funcionando. ALUControlD: %h", ALUControlD);
			
			if (PCPlus4D == 32'h28) $display("1.13- Señal PCPlus4D funcionando: %h", PCPlus4D);
			if (PCD == 32'h24) $display("1.14- Señal PCD funcionando: %h", PCD);
		      
		$finish;
		
	end
	
endmodule