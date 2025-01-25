`timescale 1ns / 1ps
`include "Instruction_Memory.sv"

// Fetch_Stage 
////// Falta un mejor entendimiento del Instruction Memory
////// Falta realizar Testbench
////////////////////////////

module Fetch_Stage(
    input logic clk, rst, 
	input logic PCSrcE, StallF,
    input logic [31:0] PCTargetE,
    inout logic [31:0] PCPlus4F,
    output logic [31:0] PCF_postff, InstrF
);

    logic [31:0] PCF_preff;

/*  MUX2to1 ProgramCounterMux(       (Utilizando mux parametrizado)
	.in0(PCPlus4F),
	.in1(PCTargetE),
	.out(PCF_preff),
	.selector(PCSrcE)
	);
	*/
	
    always_comb begin										//	Mux Previo al FF del Program Counter
        case(PCSrcE)
            1'b0: PCF_preff = PCPlus4F;
            1'b1: PCF_preff = PCTargetE;
        endcase 
    //También puede utilizarse "assign PCF_preff = PCSrcE ? PCTargetE : PCPlus4F;" para simplificar el always_comb
    end

    always_ff @(posedge clk or posedge rst) begin  			// FF del Program Counter
        if(rst)
            PCF_postff <= 32'b0;
		else if(!StallF)
			PCF_postff <= PCF_preff;
    end

	assign PCPlus4F = PCF_postff + 32'd4;                	// Adder para el PC+4

	Instruction_Memory InstrMem(							// Instruction Memory *
	.address(PCF_postff),
	.instruction(InstrF)						
	);

endmodule