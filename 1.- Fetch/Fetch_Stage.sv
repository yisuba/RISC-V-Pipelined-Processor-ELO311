`timescale 1ns / 1ps

// Fetch_Stage 
////// Falta un mejor entendimiento del Instruction Memory
////// Falta realizar Testbench
////////////////////////////

module Fetch_Stage(
    input logic clk, rst, 
	input logic PCSrcE, StallF,
    input logic [31:0] PCTargetE,
    output logic [31:0] PCPlus4F,					//verificar si es necesariamente inout
    output logic [31:0] PCF_postff, InstrF
);

/*  MUX2to1 ProgramCounterMux(       (Utilizando mux parametrizado (relativamente innecesario de momento))
	.in0(PCPlus4F),
	.in1(PCTargetE),
	.out(PCF_preff),
	.selector(PCSrcE)
	);
	*/
	
	logic [31:0] PCF_preff;
    always_comb begin								//	Mux Previo al FF del Program Counter
        case(PCSrcE)								// Podría utilizarse "assign PCF_preff = PCSrcE ? PCTargetE : PCPlus4F;" para simplificar
            1'b0: PCF_preff = PCPlus4F;
            1'b1: PCF_preff = PCTargetE;
            default: PCF_preff = PCPlus4F;
        endcase 
    end
    
    always_ff @(posedge clk or posedge rst) begin  	// FF del PC
        if(rst)
            PCF_postff <= 32'b0;
		else if(!StallF)
			PCF_postff <= PCF_preff;
    end

	assign PCPlus4F = PCF_postff + 32'd4;           // Adder para el PC+4

    // Instancia de Instruction Memory 
	Instruction_Memory InstrMem(					
        .Address(PCF_postff),
        .Instruction(InstrF)						
	);

endmodule