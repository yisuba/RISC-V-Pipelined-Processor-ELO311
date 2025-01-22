
// Immediate / Extend
////// Solo carcasa, falta funcionamiento general
////////////////////////////

module Extend(
	input logic [31:0] InstrD,
	input logic [1:0] ImmSrcD,
	output logic [24:0] ExtImmD
);

	assign ExtendIn = InstrD[31:7];
	


endmodule