
// Instruction_Memory 
////// REVISAR PARA CARGAR INSTRUCCIONES DESDE UN ARCHIVO
////// En caso de agregar instr, cambiar i del for
////// Instruction Memory Max Memory = (WordQuantity * 4[byte/word]); => 1KiloByte
//////  BitSize -> log2(WordQuantity) = BitSize 
////////////////////////////

module Instruction_Memory #(parameter WordQuantity = 256, parameter BitSize = 8)(	
	input logic [31:0] Address,				                
	output logic [31:0] Instruction				     		// ReadData	/ Instruction		
);
	logic [31:0] Memory[WordQuantity-1:0];					// Memory es un array de tamaño WordQuantity

    always_comb begin											// Inicialización de un programa (asignación instrucciones en memoria) 
		if(rst) begin
			Memory[0]  = 32'h0000_0093; // ADDI x1, x0, 0 			//dirección 0x0000_0000 -> ... 0000_00|00
			Memory[1]  = 32'h0010_0113; // ADDI x2, x0, 1			//dirección 0x0000_0004 -> ... 0000_01|00
			Memory[2]  = 32'h0020_8193; // ADDI x3, x1, 2			//dirección 0x0000_0008 -> ... 0000_10|00
			Memory[3]  = 32'h0031_0213; // ADDI x4, x2, 3			//dirección 0x0000_000C -> ... 0000_11|00
			Memory[4]  = 32'h0041_8293; // ADDI x5, x3, 4			//dirección 0x0000_0010 -> ... 0001_00|00
			Memory[5]  = 32'h0052_0313; // ADDI x6, x4, 5			//dirección 0x0000_0014 -> ... 0001_01|00
			
			for (int i = 6; i < WordQuantity; i++) begin
				Memory[i] = 32'b0; 							// Resto de la instr. memory rellenada con NOPs
			end
		end
		
		Instruction = Memory[Address[BitSize+1:2]]; 		// Address[Bitsize:2] entrega el valor como decimal, siendo esta una posición del array memory
		
    end	 
endmodule