
// Register_File
////// Falta checkear si es necesario el posedge (comparar)
////////////////////////////

module Register_File(
	input logic clk, rst,  WriteEnable,		// Recordar negar clk, WE3
	input logic [4:0] Register1, Register2, RegisterDestination,  // A1, A2, A3
	input logic [31:0] WriteData,			// WD3		
	output logic [31:0] RegisterData1, RegisterData2	// RD1, RD2
);

    logic [31:0] Register [31:0];					// Declaración de array de 31 registros de 31 bits
    assign Register[0] = 32'h0;

    always_ff @(negedge clk or posedge rst) begin	// Inicialización de register_file
        if (rst) 
            for (int i = 1; i < 32; i++)            // Todos los registros = 0 (excepto 0x0(zero))
                Register[i] <= 32'b0;	
				
        else if (WriteEnable && RegisterDestination != 5'b0)
            Register[RegisterDestination] <= WriteData; 					// ResultW se escribe en el registro de destino RdW	
    end

    assign RegisterData1 = (Register1 == 5'b0) ? 32'b0 : Register[Register1];	//asignación de registros (posiblemente operandos) para ser utilizados luego 
    assign RegisterData2 = (Register2 == 5'b0) ? 32'b0 : Register[Register2];

endmodule
/* 
	llegan los registros 1 y 2 de 5 bits c/u y si WE3==1, se escriben los datos que existen 
	en WD3 en la dirección dada por Register[RegisterDestination], significando esto
	que RegisterDestination entregará la posición en la que se deberá escribir el dato.
	Dato que tedrá 32 bits.
	Esto significaría que solo se pueden almacenar datos en 31 registros (sin el x0).
	Aparentemente esto significa que los registros son Word Addressable?
*/