
// Instruction_Memory 
////// En caso de agregar instr, cambiar i del for
////// Instruction Memory Max Memory = (WordQuantity * 4[byte/word]); => 1KiloByte
//////  BitSize -> log2(WordQuantity) = BitSize 
////////////////////////////

module Instruction_Memory #(parameter WordQuantity = 256, parameter BitSize = 8)(	
	input logic [31:0] Address,				                
	output logic [31:0] Instruction				     			
);
	logic [31:0] Memory[WordQuantity-1:0];					// Memory es un array de tamaño WordQuantity

    always_comb begin											// Inicializacion de un programa (asignacion instrucciones en memoria) 
		$readmemh("Instructions.hex", Memory);
		Instruction = Memory[Address[BitSize+1:2]]; 		// Address[Bitsize:2] entrega el valor como decimal, siendo esta una posición del array memory	
    end	 
endmodule