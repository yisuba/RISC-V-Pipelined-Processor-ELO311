
// Instruction_Memory 
////// 
////// Falta realizar Testbench
////////////////////////////

module Instruction_Memory #(parameter WordQuantity = 256, parameter BitSize = 8)(	// Instruction Memory de 1 KiloByte de memoria (256*4)
	input logic [31:0] address,				                // Address
	output logic [31:0] instruction				     		// ReadData	/ instruction		
);
	logic [31:0] memory [WordQuantity-1:0];					// memory se convierte en un array de WordQuantity, lo que entrega la cantidad de memoria máxima (en [bytes]) dado por WordQuantity * 4[byte/word]

    initial begin											// Inicialización de un programa (asignación instrucciones en memoria) ***REVISAR PARA 	CARGAR INSTRUCCIONES DESDE UN ARCHIVO
	
        memory[0]  = 32'h00000093; // ADDI x1, x0, 0 (verificar todos)	//dirección 0x0000_0000 -> ... 0000_00|00
        memory[1]  = 32'h00100113; // ADDI x2, x0, 1					//dirección 0x0000_0004 -> ... 0000_01|00
        memory[2]  = 32'h00208193; // ADDI x3, x1, 2					//dirección 0x0000_0008 -> ... 0000_10|00
        memory[3]  = 32'h00310213; // ADDI x4, x2, 3					//dirección 0x0000_000C -> ... 0000_11|00
        memory[4]  = 32'h00418293; // ADDI x5, x3, 4					//dirección 0x0000_0010 -> ... 0001_00|00
        memory[5]  = 32'h00520313; // ADDI x6, x4, 5					//dirección 0x0000_0014 -> ... 0001_01|00
		
        for (int i = 6; i < WordQuantity; i++) begin
            memory[i] = 32'b0; 											// El resto del programa (resto de la memoria) se rellenará con NOPs (En caso de agregar instr, cambiar i)
        end
    end	

    always_comb begin
        instruction = memory[address[BitSize+1:2]]; 		// address[Bitsize:2] entrega el valor que existe en los bits del 2 al Bitsize+1 como decimal para castear una posición del array memory
    end
	
endmodule