
// Immediate / Extend
////// Solo carcasa, falta funcionamiento general
////////////////////////////

module Extend(
	input logic [31:0] InstrD,
	input logic [2:0] ImmSrcD,						// modificado de la imagen (2bits)
	output logic [32:0] ExtImmD
);
	

	always_comb begin
		case(ImmSrcD) 
			3'b000:									// I-type						
				ExtImmD = {}
			3'b001:									// S-Type
				ExtImmD = 
			3'b010:									// B-Type
				ExtImmD =
			3'b011:									// U-Type
				ExtImmD =
			3'b100:									// J-Type
				ExtImmD =
		endcase
	end
endmodule








    always_comb begin
        case (ImmSrcD)
            2'b00: begin // I-Type (inmediato en bits [31:20])
                ExtImmD = {{20{InstrD[31]}}, InstrD[31:20]}; // Extensión de signo
            end
            
            2'b01: begin // S-Type (inmediato en bits [31:25] y [11:7])
                ExtImmD = {{20{InstrD[31]}}, InstrD[31:25], InstrD[11:7]};
            end
            
            2'b10: begin // B-Type (branch, bits [31], [7], [30:25], [11:8])
                ExtImmD = {{19{InstrD[31]}}, InstrD[31], InstrD[7], InstrD[30:25], InstrD[11:8], 1'b0};
            end

            2'b11: begin // U-Type (upper immediate, bits [31:12])
                ExtImmD = {InstrD[31:12], 12'b0};
            end

            3'b100: begin // J-Type (jump, bits [31], [19:12], [20], [30:21])
                ExtImmD = {{11{InstrD[31]}}, InstrD[31], InstrD[19:12], InstrD[20], InstrD[30:21], 1'b0};
            end

            default: begin // Caso por defecto (por seguridad)
                ExtImmD = 32'b0;
            end
        endcase
    end
endmodule
