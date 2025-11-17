`timescale 1ns / 1ps

// Hazard_Unit
////// Realizar TestBench para verificar un funcionamiento correcto
////// No debería producirse delay de 3 por lectura asincronica (CREO)
////// Quizás se necesite agregar una flag para caso lw donde se necesita un forwarding
////// Quizás falta un default para los Stall y FLush para que no queden como X
////////////////////////////

module Hazard_Unit(
	input logic PCSrcE, RegWriteM, RegWriteW,
	input logic [1:0] ResultSrcE,
	input logic [4:0] Rs1D, Rs2D, Rs1E, Rs2E, RdE, RdM, RdW,
	output logic StallF, StallD, FlushD, FlushE,
	output logic [1:0] ForwardAE, ForwardBE
);
	always_comb begin
	//Inicializacion de señales para evitar indeterminacion (X), ya que produce problemas con el PC
		StallF = 0;
		StallD = 0;
		FlushE = 0;
		FlushD = 0;
		ForwardAE = 2'b00;
		ForwardBE = 2'b00;

	//Caso data forwarding o bypassing (se necesita un registro que aun no se escribe)
		if ((RdM == Rs1E) && (RdM != 0) && (RegWriteM == 1))
			ForwardAE = 2'b10;
		if ((RdM == Rs2E) && (RdM != 0) && (RegWriteM == 1))
			ForwardBE = 2'b10;	// ^Si la instruccion sgte no a�n no se ha cargado

		if ((RdW == Rs1E) && (RdW != 0) && (RegWriteW == 1))
			ForwardAE = 2'b01;
		if ((RdW == Rs2E) && (RdW != 0) && (RegWriteW == 1))
			ForwardBE = 2'b01;	// ^Si la instruccion sgte no a�n no se ha cargado

	//Caso lw (analisis con lw en execute y data forwarding instruccion sgte)
		if ((ResultSrcE == 2'b01) && ((RdE == Rs1D) || (RdE == Rs2D)) && (RdE != 0)) begin //fixed. detectaba el offset como registro, lo que produc�a falsos casos de lw hazar
			StallF = 1;
			StallD = 1;
			FlushE = 1;
		end

	//Caso Branch Prediction (Never Taken)
		if (PCSrcE == 1) begin
			FlushD = 1;
			FlushE = 1; //VERIFICAR QUE NO FALTE NADA MAS
		end
	end
endmodule