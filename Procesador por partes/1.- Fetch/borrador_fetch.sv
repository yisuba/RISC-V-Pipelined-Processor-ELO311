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
	.A(PCF_postff),
	.RD(InstrF)												//ReadData
	);

endmodule

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// Instruction Memory 
module Instruction_Memory #(parameter WordQuantity = 256)(	// Instruction Memory de 1 KiloByte de memoria (256*4)
	input logic [31:0] address,
	output logic [31:0] instruction					

	logic [31:0] memory [WordQuantity-1:0];					// memory se convierte en un array de WordQuantity, lo que entrega la cantidad de memoria máxima (en [bytes]) dado por WordQuantity * 4[byte/word]

    initial begin											// Inicialización de un programa (asignación instrucciones en memoria)
	
        memory[0]  = 32'h00000093; // ADDI x1, x0, 0 (verificar todos)	//dirección 0x0000_0000 -> ... 0000_00|00
        memory[1]  = 32'h00100113; // ADDI x2, x0, 1					//dirección 0x0000_0004 -> ... 0000_01|00
        memory[2]  = 32'h00208193; // ADDI x3, x1, 2					//dirección 0x0000_0008 -> ... 0000_10|00
        memory[3]  = 32'h00310213; // ADDI x4, x2, 3					//dirección 0x0000_000C -> ... 0000_11|00
        memory[4]  = 32'h00418293; // ADDI x5, x3, 4					//dirección 0x0000_0010 -> ... 0001_00|00
        memory[5]  = 32'h00520313; // ADDI x6, x4, 5					//dirección 0x0000_0014 -> ... 0001_01|00
		
        for (int i = 6; i < 256; i++) begin
            memory[i] = 32'h00000000; 						// El resto del programa (resto de la memoria) se rellenará con NOPs
        end
    end	

    always_comb begin
        instruction = memory[address[9:2]]; 				// address[9:2] entrega el valor que existe en esos 8 bits como un decimal para castear una posición del array memory
    end
	
endmodule


			