`timescale 1ns / 1ps

// tb_Execute_Stage
////// evaluar el caso del ZeroE (para branches) y mÃ¡s seÃ±ales
////// evaluar otras instrucciones que utilicen mÃ¡s seÃ±ales
////////////////////////////

module tb_Execute_Stage;
	logic JumpE, BranchE, ALUSrcE;
	logic [1:0] ForwardAE, ForwardBE;
	logic [3:0] ALUControlE;						
	logic [31:0] PCE, ExtImmE, RD1E, RD2E;
	logic [31:0] ALUResultM, ResultW;
	logic RegWriteE, MemWriteE;
	logic [1:0] ResultSrcE;
	logic [4:0] Rs1E, Rs2E, RdE;
	logic [31:0] PCPlus4E;
	logic [31:0] ALUResultE, WriteDataE;			
	logic [31:0] PCTargetE;
	logic PCSrcE;

	Execute_Stage DUT(
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
        .RdE(RdE),
        .PCPlus4E(PCPlus4E),
        .ALUResultE(ALUResultE),
        .WriteDataE(WriteDataE),
        .PCTargetE(PCTargetE),
        .PCSrcE(PCSrcE)	
	);
	
	initial begin
		RegWriteE = 1'b1;
		ResultSrcE = 2'b00;
		MemWriteE = 1'b0;
		RdE = 5'h3;
		PCPlus4E = 32'h28;
		
		JumpE = 1'b0;
		BranchE = 1'b0;
		ALUControlE = 4'b0;
		ALUSrcE = 1;
		RD1E = 32'h7;
		RD2E = 32'h5555;
		PCE =  32'h24;
		Rs1E = 5'h1;
		Rs2E = 5'h2;
		ExtImmE = 32'h2;
		ForwardAE = 2'b00;	//pasa RD1E
		ForwardBE = 2'b00;	//pasa RD2E
		ALUResultM = 32'hCC;		// Si ForwardAE o ForwardBE = 2'b10
		ResultW = 32'h58;			// Si ForwardAE o ForwardBE = 2'b01
		
		//ALUResultE = RD1E + ExtImmE => 32'h9		
		//PCTargetE = PCE + ExtImmE => 32'h28
		
		#10 //10ns		
	
		if(RegWriteE == 1) $display("1.1- RegWriteE pasó correctamente a la sgte etapa. RegWriteE: %h", RegWriteE);
		if(ResultSrcE == 2'b00) $display("1.2- ResultSrcE pasó correctamente a la sgte etapa. ResultSrcE: %h", ResultSrcE);
		if(MemWriteE == 0) $display("1.3- MemWriteE pasó correctamente a la sgte etapa. MemWriteE: %h", MemWriteE);

		if(DUT.SrcAE == 32'h7) $display("1.4- SrcAE pasó correctamente por el MUX. SrcAE: %h", DUT.SrcAE);
		if(WriteDataE == 32'h5555) $display("1.5- WriteDataE pasó correctamente por el MUX. SrcBE: %h", WriteDataE);
		if(DUT.SrcBE == 32'h2) $display("1.6- SrcBE pasó correctamente por el MUX. SrcBE: %h", DUT.SrcBE);
		if(PCTargetE == 32'h26) $display("1.7- PCTargetE pasó correctamente por el Adder. PCTargetE: %h", PCTargetE);
		if(DUT.ZeroE == 1'b0) $display("1.8- Flag ZeroE resultó ser correcta despues de la ALU. ZeroE: %b", DUT.ZeroE);
		if(JumpE == 1'b0) $display("1.9- JumpE resultó ser correcta para compararse. JumpE: %b", JumpE);
		if(BranchE == 1'b0) $display("1.10- BranchE resultó ser correcta para compararse. BranchE: %b", BranchE);
		if(PCSrcE == 1'b0) $display("1.11- PCSrcE resultó ser correcta despues de la ALU. PCSrcE: %h", PCSrcE);
		if(ALUResultE == 32'h9) $display("1.12- ALUResultE resultó ser correcta despues de la ALU. ALUResultE: %h", ALUResultE);
	
		if(RdE == 5'h3) $display("1.13- RdE pasó correctamente a la sgte etapa. RdE: %h", RdE);
		if(PCPlus4E == 32'h28) $display("1.14- PCPlus4E pasó correctamente a la sgte etapa. PCPlus4E: %h", PCPlus4E);
		

		$finish;
	end

endmodule