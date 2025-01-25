
// Register_File
////// Solo carcasa, falta funcionamiento general
////////////////////////////

module Register_File(
	input logic clk, rst,  WE3,						//Recordar negar clk
	input logic [4:0] A1, A2, A3,
	input logic [4:0] WD3,							//Revisar bus de bits de WD3 ¿Cuantos bits podría o debería tener?
	output logic [4:0] RD1D, RD2D
);

endmodule