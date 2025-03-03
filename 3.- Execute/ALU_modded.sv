`timescale 1ns / 1ps

// ALU modificada
////// Modificada en base a una ALU generica + chatgpgt
////// Revisar instrucciones sll, srl, sra, slt, sltu y su funcionamiento
////////////////////////////

module ALU_Modded #(parameter Bits = 32)(
    input logic [Bits-1:0] A, B,          // A <- (SrcAE), B <- (SrcBE)
    input logic [2:0] BranchType,
    input logic [3:0] OpCode,       

    output logic BranchTaken,     
    output logic [Bits-1:0] Result               
);
    always_comb begin
        case (OpCode)							 //Que operacion?
            4'b0000: Result = A + B;                   			 //add
            4'b0001: Result = A - B;          			         //sub
            4'b0010: Result = A ^ B;     		                 //xor			
            4'b0011: Result = A | B;                      		 //or
            4'b0100: Result = A & B;            		         //and
            4'b0101: Result = A << B[$clog2(Bits)-1:0];          //slL (shift left Logical)
            4'b0110: Result = A >> B[$clog2(Bits)-1:0];          //srL (shift right Logical)
            4'b0111: Result = $signed(A) >>> B[$clog2(Bits)-1:0];//srA (shift right Arithmetical)
            4'b1000: Result = ($signed(A) < $signed(B)) ? 1 : 0; //slt (set less than $signed)
            4'b1001: Result = (A < B) ? 1 : 0;                   //SLTU (set less than unsigned)
            default: Result = {Bits{1'bx}};                          		 
        endcase

        case (BranchType)						//Que instruccion branch? 		
            3'h0: BranchTaken = (Result == {Bits{1'b0}});        // beq DONE (sub)
            3'h1: BranchTaken = (Result != {Bits{1'b0}});             // bne DONE (sub)
            3'h4: BranchTaken = Result;                          // blt DONE (slt)
            3'h5: BranchTaken = ~Result;                         // bge DONE (~slt)
            3'h6: BranchTaken = Result;                          // bltu DONE (sltu)
            3'h7: BranchTaken = ~Result;                         // bgeu DONE (~sltu)
            default: BranchTaken = 0;
        endcase
    end
endmodule