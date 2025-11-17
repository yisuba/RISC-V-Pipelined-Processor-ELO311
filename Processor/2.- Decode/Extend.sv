`timescale 1ns / 1ps

// Immediate / Extend
/// *** Para B and J types, el valor de inmediato no tiene offset de 2 bits sino solo de 1
////////////////////////////

module Extend(
	input logic [2:0] ImmSrcD,			
	input logic [31:0] InstrD,
	
	output logic [31:0] ExtImmD
);
	
	always_comb begin
		case(ImmSrcD) 
			3'b000:		// I-type					
				ExtImmD = {{20{InstrD[31]}}, InstrD[31:20]};
				
			3'b001:		// S-Type
				ExtImmD = {{20{InstrD[31]}} , InstrD[31:25], InstrD[11:7]};
				
			3'b010:		// B-Type (no [0] por direcciones)
				ExtImmD = {{19{InstrD[31]}} ,InstrD[31], InstrD[7], InstrD[30:25], InstrD[11:8], 1'b0};
				
			3'b011:		// U-Type (upper imm)
				ExtImmD = {InstrD[31:12], 12'b0};
				
			3'b100:		// J-Type (no [0] por direcciones)
				ExtImmD = {{11{InstrD[31]}}, InstrD[31], InstrD[19:12], InstrD[20], InstrD[30:21], 1'b0};
				
			default: ExtImmD = 32'bx;
		endcase
	end
endmodule