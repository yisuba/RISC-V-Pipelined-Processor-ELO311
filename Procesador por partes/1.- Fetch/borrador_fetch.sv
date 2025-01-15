`timescale 1ns / 1ps


///// 09/01/25
// Etapa de Fetch 
////// Está el Mux + FF + Adder del Program Counter
////// Falta el funcionamiento del Instruction Memory (solo está el modulo y sus IO)
////// Falta implementar el FF de salida de la etapa de Instruction_Fetch
////////////////////////////

module Instruction_Fetch_Stage(
    input logic clk, rst, 
	input logic PCSrcE, StallF
    input logic [31:0] PCTargetE,
    inout logic [31:0] PCPlus4F,
    output logic [31:0] PCF_postff, InstrF
);

    logic [31:0] PCF_preff;

/*  MUX2to1 ProgramCounterMux(       (Utilizando modulos previos)
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
    //También puede utilizarse "assign PCF_preff = PCSrcE ? PCTargetE : PCPlus4F;"
    end

    always_ff @(posedge clk or posedge rst) begin  			// FF del Program Counter
        if(rst)
            PCF_postff <= 32'b0;
		else if(!StallF)
			PCF_postff <= PCF_preff;
    end

	assign PCPlus4F = PCF_postff + 32'd4;                	// Adder para el PC+4

	logic [31:0] InstrF;

	Instruction_Memory InstMem(								// Instruction Memory *Solo carcasa del módulo
	.rst(rst),
	.A(PCF_postff),
	.RD(InstrF)
	);

endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Instruction_Memory(									// Instruction Memory *Solo carcasa del módulo
	input logic rst,
	input logic [31:0] A,
	output logic [31:0] RD
	);

endmodule

	logic [31:0] 
	always_ff @(posedge clk or posedge rst) begin			// FF de salida de la Instruction_Fetch
		if(rst) begin
			InstrF <= 32'b0;
			PCF_postff <= 32'b0;
			PCPlus4F <= 32'b0;
			end
		else if(StallD) 
			