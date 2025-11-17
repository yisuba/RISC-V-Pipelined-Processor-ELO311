`timescale 1ns / 1ps

// Data_Memory
////// Checkear que la lectura sea o no asincrona, ¿difiere lo lógico de lo teorico? Pareciera ser que se escribe en el posedge según imagen de microarquitectura. Revisar
////// WordQuantity * 4[byte/word] => Memoria máxima. En este caso 1024 [bytes] => 1[Kb]
////// 
////// Será necesario no dejar que se utilice 0xFFFF_FFFF como dirección ya q no es alineada?
////// Bitsize = 8 -> max posicion Memory[255] -> address 11_1111_11|00 -> 0x0000_03FC
//////
////// Agregar soporte para lb, lh
////////////////////////////

module Data_Memory #(parameter WordQuantity = 256, parameter BitSize = 8)(    	
    input logic clk, rst, WriteEnable,
	input logic [1:0] StoreType,
    input logic [31:0] Address, WriteData,	
    output logic [31:0] ReadData 		
);

    logic [31:0] Memory[0:WordQuantity-1];

    always_ff @(negedge clk or posedge rst) begin
    
        // Inicializacion de data_memory
        if (rst) begin	
				for (int i = 0; i < WordQuantity; i++)
				    Memory[i] <= 32'b0;
		end
		
		// Escritura. Se usan los bits [9:2] para evadir el offset de c/ word		
		else if (WriteEnable) /*begin                        
			case (StoreType)
				2'b00: Memory[Address[BitSize+1:2]][(Address[1:0] * 8) +: 8] <= WriteData[7:0]; //sb (2LSB *8)
				2'b01: Memory[Address[BitSize+1:2]][(Address[1] * 16) +: 16] <= WriteData[15:0]; //sh (1LSB *16)
				2'b10: Memory[Address[BitSize+1:2]] <= WriteData; //sw (2LSB offset)
				default: Memory[Address[BitSize+1:2]] <= 32'bx;
			endcase				EL INDEX DE QUE BYTE O QUE HALF SOLO RECIBE LA MITAD SUPERIOR O EL BYTE SOBRE EL 0 ?!?!?
    end*/			
			Memory[Address[BitSize+1:2]] <= WriteData;
    end
    always_comb begin
        if (WriteEnable == 0)                             // Lectura. Asincronica
		/*	case (LoadType)
				2'b00: ;
				2'b01: ;
				2'b10: ;
				default: ;
			endcase		*/
				ReadData = Memory[Address[BitSize+1:2]];
        else
            ReadData = 32'bx;
    end      
    
endmodule