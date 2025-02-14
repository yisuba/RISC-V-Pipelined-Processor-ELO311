
// Data_Memory
////// Checkear que la lectura sea o no asincrona, ¿difiere lo lógico de lo teorico? Pareciera ser que se escribe en el posedge según imagen de microarquitectura. Revisar
////// WordQuantity * 4[byte/word] => Memoria máxima. En este caso 1024 [bytes] => 1[Kb]
////// 
////// Será necesario no dejar que se utilice 0xFFFF_FFFF como dirección ya q no es alineada?
////// Bitsize = 8 -> max posicion Memory[255] -> address 11_1111_11|00 -> 0x0000_03FC
////////////////////////////

module Data_Memory #(parameter WordQuantity = 256, parameter BitSize = 8)(    	
    input logic clk, rst, WriteEnable,
    input logic [31:0] Address, WriteData,	
    output logic [31:0] ReadData 		
);

    logic [31:0] Memory[0:WordQuantity-1];

    always_ff @(negedge clk or posedge rst) begin		
        if (rst) 
			for (int i = 0; i < WordQuantity; i++)		// Inicialización
				Memory[i] <= 32'b0;
				
		else if (WriteEnable) begin
            Memory[Address[BitSize+1:2]] <= WriteData; 		// Escritura. Se usan los bits [9:2] para evadir el offset
        end
    end

    assign ReadData = (!WriteEnable) ? Memory[Address[BitSize+1:2]] : 32'b0; // Combinacional / Asincrono ...
endmodule