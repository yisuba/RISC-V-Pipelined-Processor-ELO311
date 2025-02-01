
// Register_File
////// Solo carcasa, falta funcionamiento general
////////////////////////////

module Register_File(
	input logic clk, rst,  WE3,						//Recordar negar clk
	input logic [4:0] A1, A2, A3,
	input logic [31:0] WD3,						
	output logic [31:0] RD1, RD2
);

    logic [31:0] registers [31:0];					// Declaración de array de 31 registros de 31 bits

    always_ff @(negedge clk or posedge rst) begin	// Inicialización de register_file
        if (rst) 
            for (int i = 1; i < 32; i++)            // Todos los registros = 0 (excepto 0x0(zero))
                registers[i] <= 32'b0;				
        else if (WE3 && A3 != 5'b00000)
            registers[A3] <= WD3; 					// ResultW se escribe en el registro de destino RdW	
    end

    assign RD1 = (A1 == 5'b00000) ? 32'b0 : registers[A1];	//asignación de registros (posiblemente operandos) para ser utilizados luego 
    assign RD2 = (A2 == 5'b00000) ? 32'b0 : registers[A2];

endmodule
