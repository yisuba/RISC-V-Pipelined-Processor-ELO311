`timescale 1ns / 1ps

// Register_File
////// Falta checkear si es necesario el posedge (comparar)
////////////////////////////

module Register_File(
	input logic clk, rst,  WriteEnable,		// WE3
	input logic [4:0] Register1, Register2, RegisterDestination,  // A1, A2, A3
	input logic [31:0] WriteData,			// WD3		
	output logic [31:0] RegisterData1, RegisterData2	// RD1D, RD2D
);
    
    // Declaracion de array de 32 registros de 32 bits
    logic [31:0] Registers [31:0];					
  
    always_ff @(negedge clk or posedge rst) begin	
    
        // Inicializacion de register_file
        if (rst) begin
            Registers[0] <= 32'h0;
            Registers[1] <= 32'h5555;
			Registers[2] <= 32'h3333;
            for (int i = 3; i < 32; i++)            
                Registers[i] <= 32'b0;	
		end
		
		// Para que ResultW se escribe en el registro de destino RdW	
        else if (WriteEnable && RegisterDestination != 5'b0)        
            Registers[RegisterDestination] <= WriteData; 			
    end

    /* Busqueda de registros en base a sus entradas Register1 y Register2
    (Dentro de always_comb para prevenir inferencias (latches)*/
    always_comb begin
        if (Register1 != 5'h0)
            RegisterData1 = Registers[Register1];
        else 
            RegisterData1 = 32'b0;
           
        if (Register2 != 5'h0)
            RegisterData2 = Registers[Register2];
        else 
            RegisterData2 = 32'b0;
    end
endmodule
/* 
    Aparentemente los registros actualmente son word-addressable
    Register1 y Register2 son indicadores de la posición de datos de array
    WriteData se escribe en Registers[Rd]
*/