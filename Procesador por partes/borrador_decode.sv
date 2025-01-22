module Instruction_Decode_Stage(
	input logic clk, rst
	input logic [31:0] InstrD, PCD, PCPlus4D,
	input logic [4:0] RdW, ResultW,						//Revisar bus de bits de ResultW
	input logic RegWriteW,
	output logic [4:0] RD1D, RD2D, Rs1D, Rs2D, RdD,
	output logic [24:0] ExtImmD
	output logic RegWriteD, MemWriteD, JumpD, BranchD, AluSrcD,		//Control Unit signals
	output logic [1:0] ResultSrcD,
	output logic [3:0] ALUControlD		//Modificado a [3:0] para adecuarse al RV32I
);


	Control_Unit CtrlUnit(				//instancia de ControlUnit
	.InstrD(InstrD),
	.RegWriteD(RegWriteD),
	.ResultSrcD(ResultSrcD),
	.MemWriteD(MemWriteD),
	.JumpD(JumpD),
	.BranchD(BranchD),
	.ALUControlD(ALUControlD),
	.AluSrcD(AluSrcD),
	.ImmSrcD(ImmSrcD)
	);


	logic [4:0] A1, A2;
	assign A1 = InstrD[19:15];
	assign A2 = InstrD[24:20];
	Register_File RegFile(				//instancia de RegisterFile
	.clk(clk),
	.rst(rst),
	.WE3(RegWriteW),
	.A1(A1),
	.A2(A2),
	.A3(RdW),
	.WD3(ResultW),
	.RD1D(RD1D),
	.RD2D(RD2D)
	);
	
	assign Rs1D = InstrD[19:15];		//Cables 
	assign Rs2D = InstrD[24:20];
	assign RdD = InstrD[11:7];
	
	
	logic [24:0] Extend_in;
	logic [1:0] ImmSrcD;
	assign Extend_in = InstrD[31:7];
	Extend ExtImm(						//instancia del Extend/Immediate
	.ImmSrcD(ImmSrcD),
	.Extend_in(Extend_in),
	.ExtImmD(ExtImmD)
	);
	
endmodule





////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

//Register File *solo carcasa*
module Register_File(
	input logic clk, rst,  WE3,						//Recordar negar clk
	input logic [4:0] A1, A2, A3,
	input logic [4:0] WD3,							//Revisar bus de bits de WD3 ¿Cuantos bits podría o debería tener?
	output logic [4:0] RD1D, RD2D
);

endmodule


//Inmediado / Extend *solo carcasa*
	module Extend(
		input logic [24:0] Extend_in,
		input logic [1:0] ImmSrcD,
		output logic [24:0] ExtImmD
	);

endmodule




//Unidad de control *solo carcasa*
module Control_Unit(
	input logic [31:0] InstrD,
	output logic RegWriteD, MemWriteD, JumpD, BranchD, AluSrcD,
	output logic [1:0] ResultSrcD, ImmSrcD,
	output logic [2:0] ALUControlD
);


	logic [6:0] op;		
	assign op = InstrD[6:0];
	logic [2:0] funct3;
	assign funct3 = InstrD[14:12];
	logic [6:0] funct7;
	assign funct7 = InstrD[31:25];

/*	PROTOTIPO MIO (POCO CLARO)
	case (op)
		7'b011_0011: begin							// R-type						***
			case(funct3): 							//Qué instrucción del tipo R?
				3'b000: begin
					if(funct7==7'b010_0000)begin	// SUB
						ALUControlD = 3'b000;		
					end
					else
						ALUControlD	= 3'b001;			// ADD
				end
				3'b101: begin
					if(funct7==7'b0010_0000)		// Shift Right Arithmetical
						ALUControlD;
				end
			endcase
		end
		
		7'b001_0011: begin							// I-type (W/ no memory)		***
			case(funct3): begin						//Qué instrucción del tipo I?
				
				
			endcase
		end
	
		7'b000_0011: begin							// I-type (W/ memory)			***
			case(funct3): begin						//Qué instrucción load?
			
			endcase
		end
		
		7'b010_0011: begin							// S-type 						***
			case(funct3): begin						//Qué instrucción store? 
			
			endcase
		end
		
		7'b110_0011: begin							// B-type						***
			case(funct3): begin						//Qué instrucción branch? 		
			
			endcase
		end
		
		7'b110_1111: begin							// J-type 						***
		
		end
		
		7'b110_0111: begin							// I-type (jalr) 				***
			
		end
		
		7'b011_0111: begin							// U-type (lui) 				***
		
		end
		
		7'b001_0111: begin							// U-type (auipc)				***
		
		end
		
		7'b111_0011: begin							// I-type (ecall / eberak)		***Transfer control to OS/debugger
		
		end
		
		default: 									//default
	endcase
*/

	always_comb begin
		case ({op, funct3, funct7})
			{7'b011_0011, 3'b000, 7'b000_0000}:	ALUControlD = 4'b0000; 						//add		R-type
			{7'b011_0011, 3'b000, 7'b010_0000}:	ALUControlD = 4'b0001;						//sub
			{7'b011_0011, 3'b100, 7'b000_0000}:	ALUControlD = 4'b0010;						//xor
			{7'b011_0011, 3'b110, 7'b000_0000}:	ALUControlD = 4'b0011;						//or
			{7'b011_0011, 3'b111, 7'b000_0000}:	ALUControlD = 4'b0100;						//and
			{7'b011_0011, 3'b001, 7'b000_0000}:	ALUControlD = 4'b0101;						//sll
			{7'b011_0011, 3'b101, 7'b000_0000}:	ALUControlD = 4'b0110;						//srl
			{7'b011_0011, 3'b101, 7'b010_0000}:	ALUControlD = 4'b0111;						//sra
			{7'b011_0011, 3'b010, 7'b000_0000}:	ALUControlD = 4'b1000;						//slt
			{7'b011_0011, 3'b011, 7'b000_0000}:	ALUControlD = 4'b1001;						//sltu
			
			{7'b001_0011, 3'b000, 7'bxxx_xxxx}:												//addi		I-type (W/ no memory)
			{7'b001_0011, 3'b100, 7'bxxx_xxxx}:												//xori		
			{7'b001_0011, 3'b110, 7'bxxx_xxxx}:												//ori
			{7'b001_0011, 3'b111, 7'bxxx_xxxx}:												//andi
			{7'b001_0011, 3'b001, 7'bxxx_xxxx}:												//slli		**
			{7'b001_0011, 3'b101, 7'bxxx_xxxx}:												//srli		**
			{7'b001_0011, 3'b101, 7'bxxx_xxxx}:												//srai		
			{7'b001_0011, 3'b010, 7'bxxx_xxxx}:												//slti
			{7'b001_0011, 3'b011, 7'bxxx_xxxx}:												//sltiu	

			{7'b000_0011, 3'b000, 7'bxxx_xxxx}:							//lb		I-type (W/ memory)
			{7'b000_0011, 3'b001, 7'bxxx_xxxx}:							//lh	
			{7'b000_0011, 3'b010, 7'bxxx_xxxx}:							//lw	
			{7'b000_0011, 3'b100, 7'bxxx_xxxx}:							//lbu
			{7'b000_0011, 3'b101, 7'bxxx_xxxx}:							//lhu

			{7'b010_0011, 3'b000, 7'bxxx_xxxx}:							//sb		S-type 
			{7'b010_0011, 3'b001, 7'bxxx_xxxx}:							//sh
			{7'b010_0011, 3'b010, 7'bxxx_xxxx}:							//sw
			
			{7'b110_0011, 3'b000, 7'bxxx_xxxx}:							//beq		B-type	
			{7'b110_0011, 3'b001, 7'bxxx_xxxx}:							//bne
			{7'b110_0011, 3'b100, 7'bxxx_xxxx}:							//blt
			{7'b110_0011, 3'b101, 7'bxxx_xxxx}:							//bge
			{7'b110_0011, 3'b110, 7'bxxx_xxxx}:							//bltu
			{7'b110_0011, 3'b111, 7'bxxx_xxxx}:							//bgeu		

			{7'b110_1111, 3'bxxx, 7'bxxx_xxxx}:							//jal		J-type (jal)
			
			{7'b110_0111, 3'b000, 7'bxxx_xxxx}:							//jalr		I-type (jalr)
			
			{7'b011_0111, 3'bxxx, 7'bxxx_xxxx}:							//lui		U-type
			{7'b001_0111, 3'bxxx, 7'bxxx_xxxx}:							//auipc
		
			{7'b111_0011, 3'b000, 7'bxxx_xxxx}:							//ecall		I-type  **
			{7'b111_0011, 3'b000, 7'bxxx_xxxx}:							//ebreak			**

			default: ALUControlD = 3'bxxx; // Undefined instruction
		endcase
	end

endmodule