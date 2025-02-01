
// Immediate / Extend
////// Aparentemente listo, falta agregar testbench
////////////////////////////

module Extend(
	input logic [31:0] InstrD,
	input logic [2:0] ImmSrcD,			// modificado de la imagen de referencia (2bits)
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
				
			default: ExtImmD = 32'b0;
		endcase
	end
endmodule