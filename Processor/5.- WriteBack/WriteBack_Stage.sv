`timescale 1ns / 1ps

// Etapa de WriteBack 
////// Falta verificar funcionamiento del stage
////// Aparentemente las señales están todas correctas
////////////////////////////

module WriteBack_Stage(
	input logic RegWriteW,
	input logic [1:0] ResultSrcW,
	input logic [2:0] LoadTypeW,
	input logic [4:0] RdW,
	input logic [31:0] ALUResultW, ReadDataW, PCPlus4W,
	
	output logic [31:0] ResultW
);

	always_comb begin							//MUX para seleccionar ResultW	   
	  
	   logic [31:0] ReadDataW_processed;	   
	   case(LoadTypeW)
	       3'b000: ReadDataW_processed = {{24{ReadDataW[7]}}, ReadDataW[7:0]};   //lb
	       3'b001: ReadDataW_processed = {{16{ReadDataW[15]}}, ReadDataW[15:0]}; //lh
	       3'b010: ReadDataW_processed = ReadDataW;                              //lw
	       3'b011: ReadDataW_processed = {24'b0, ReadDataW[7:0]};                //lbu
	       3'b100: ReadDataW_processed = {16'b0, ReadDataW[15:0]};               //lhu
	       default: ReadDataW_processed = 32'bx;
	   endcase
	   
		case(ResultSrcW)
			2'b00: ResultW = ALUResultW;             //Sin tocar Data Memory
			2'b01: ResultW = ReadDataW_processed;    //Load desde Data Memory
			2'b10: ResultW = PCPlus4W;               //Direccion PC+4 (aparentemente para ra)
			default: ResultW = 32'bx;                //caso extra
		endcase
	end	
endmodule