`timescale 1ns / 1ps

// ALU modificada
////// Modificada en base a una ALU generica + chatgpgt
////// Revisar instrucciones sll, srl, sra, slt, sltu y su funcionamiento
////////////////////////////

module ALU_modded #(parameter M = 32)(
    input logic [M-1:0] A, B,          // Operando A (RD1E/otros), Operando B (RD2E/otros or ExtImmE)
    input logic [3:0] OpCode,       
    output logic [M-1:0] Result,    
    output logic Zero               // Flag Zero para saltoss
);

    always_comb begin
        case (OpCode)
            4'b0000: Result = A + B;                       			 //add
            4'b0001: Result = A - B;              			         //sub
            4'b0010: Result = A ^ B;     		                     //xor			
            4'b0011: Result = A | B;                         		 //or
            4'b0100: Result = A & B;            		             //and
            4'b0101: Result = A << B[4:0];              		     //sll (Shift lógico a la izquierda)
            4'b0110: Result = A >> B[4:0];           		         //Srl (Shift lógico a la derecha)
            4'b0111: Result = $signed(A) >>> B[4:0];    	         //SRA (Shift aritmético a la derecha)
            4'b1000: Result = ($signed(A) < $signed(B)) ? 1 : 0; 	 //SLT (Set Less Than, signed)
            4'b1001: Result = (A < B) ? 1 : 0;               		 //SLTU (Set Less Than, unsigned)
            default: Result = 0;                          		     //Operación inválida
        endcase

        Zero = (Result == 0);
    end
endmodule