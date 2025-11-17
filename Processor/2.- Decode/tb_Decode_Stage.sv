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
	logic [1:0] ResultSrcD, StoreTypeD;
	logic [2:0] LoadTypeD, BranchTypeD;
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
        .LoadTypeD(LoadTypeD),
        .StoreTypeD(StoreTypeD),
        .BranchTypeD(BranchTypeD),
        .ALUControlD(ALUControlD)
    );
	
	always #5 clk = ~clk;
	
	initial begin
	   // Inicialización de valores
		clk = 1'b0;
		rst = 1'b1;
		InstrD = 32'h00208193; 	// addi x3, x1, 2 -> addi gp, ra, 2	(0000 0000 0010 0000 1000 0001 1001 0011)
		PCD = 32'h24;
		PCPlus4D = 32'h0000_0028;

		#10 //10ns 
            rst = 0;
            // 0x7 se escribe en x1 (negedge)
            RegWriteW = 1'b1;
            RdW = 5'h1;
            ResultW = 32'h7;		
		
		#10 //20ns
		    // 0x5555 se escribe en x2 (negedge)  
            RdW = 5'h2;
            ResultW = 32'h5555;		
		
		#15 //35ns    
			$display("Desglose de InstrD (addi x3, x1, 2):");
			if(DUT.opcode == 7'b001_0011) $display("    1.1- opcode correcto, FMT: I. opcode: %h", DUT.opcode);
			if(DUT.funct3 == 3'h0) $display("    1.2- funct3 correcto, x0. funct3: %h", DUT.funct3);
			if(DUT.funct7 == 7'h00) $display("    1.3- funct7 correcto, x00. funct7: %h", DUT.funct7);			
			if(Rs1D == 5'h1) $display("    1.4- rs1 correcto, x1 (ra). rs1: %h", Rs1D);
			if(Rs2D == 5'h2) $display("    1.5- rs2 correcto, x2 (gp). rs2: %h", Rs2D);
			if(RdD == 5'h3) $display("    1.6- rd correcto, x3 (gb). rd: %h", RdD);
			$display("Verificacion de paso de señales por los modulos:");
			//Control Unit
			if (RegWriteD == 1'b1) $display("    1.7- Señal RegWriteD funcionando. RegWriteD: %b", RegWriteD);
			if (ResultSrcD == 2'b00) $display("    1.8- Señal ResultSrcD funcionando. ResultSrcD: %b", ResultSrcD);
			if (MemWriteD == 1'b0) $display("    1.9- Señal MemWriteD funcionando. MemWriteD: %b", MemWriteD);
			if (JumpD == 1'b0) $display("    1.10- Señal JumpD funcionando. JumpD: %b", JumpD);
			if (BranchD == 1'b0) $display("    1.11- Señal BranchD funcionando. BranchD: %b", BranchD);
			if (ALUControlD == 4'b0000) $display("    1.12- Señal ALUControlD funcionando. ALUControlD: %b", ALUControlD);
			if (AluSrcD == 1'b1) $display("    1.13- Señal AluSrcD funcionando. AluSrcD: %b", AluSrcD);
			if (LoadTypeD === 3'bxxx) $display("    1.14- Señal LoadTypeD funcionando. LoadTypeD: %b", LoadTypeD);
			if (StoreTypeD === 2'bxx) $display("    1.15- Señal StoreTypeD funcionando. StoreTypeD: %b", StoreTypeD);
			if (BranchTypeD === 3'bxxx) $display("    1.16- Señal BranchTypeD funcionando. BranchTypeD: %b", BranchTypeD);
			//$display("Load: %b, Store: %b, Branch: %b", LoadTypeD, StoreTypeD, BranchTypeD);
			if (DUT.ImmSrcD == 3'b000) $display("    1.17- Señal ImmSrcD funcionando. ImmSrcD: %b", DUT.ImmSrcD);
			//Register File
			if (RD1D == 32'h7) $display("    1.18- Register Data 1 cargado correctamente. RD1D: %h", RD1D); 
			if (RD2D == 32'h5555) $display("    1.19- Register Data 2 cargado correctamente. RD2D: %h", RD2D);
			//Extend
			if (ExtImmD == 32'h2) $display("    1.20- Inmediato extendido correctamente. Imm: %h", ExtImmD);
			
			if (PCPlus4D == 32'h28) $display("    1.21- Señal PCPlus4D funcionando: %h", PCPlus4D);
			if (PCD == 32'h24) $display("    1.22- Señal PCD funcionando: %h", PCD);
		      
		$finish;
		
	end
endmodule