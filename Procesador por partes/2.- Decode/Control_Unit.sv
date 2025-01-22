
// Control_Unit
////// Solo están relativamente bien definidas las instrucciones R-type
///// FALTA perfeccionar cada una de las instrucciones
/// RegWriteD se activa si es necesario escribir rd en RegFile
/// MemWriteD se activa si es necesario escribir
/// JumpD
/// BranchD	se activa en caso de que la instrucción sea un condicional
/// AluSrcD	define si ALU tomará el operando rs2 o del imm
///	ResultSrcD
/// ImmSrcD selecciona como extender el campo immediate
/// ALUControlD define que operación tendrá que realizar la ALU
////////////////////////////

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
			{7'b011_0011, 3'b000, 7'b000_0000}:	begin 										//add		R-type
				ALUControlD = 4'b0000; 				
				RegWriteD = 1'b1;  
			end											
			{7'b011_0011, 3'b000, 7'b010_0000}:	begin 										//sub		
				ALUControlD = 4'b0001; 					
				RegWriteD = 1'b1;  
			end
			{7'b011_0011, 3'b100, 7'b000_0000}:	begin 										//xor		
				ALUControlD = 4'b0010; 					
				RegWriteD = 1'b1;  
			end
			{7'b011_0011, 3'b110, 7'b000_0000}:	begin 										//or
				ALUControlD = 4'b0011; 				
				RegWriteD = 1'b1;  
			end
			{7'b011_0011, 3'b111, 7'b000_0000}:	begin 										//and
				ALUControlD = 4'b0100; 					
				RegWriteD = 1'b1;  
			end
			{7'b011_0011, 3'b001, 7'b000_0000}:	begin 										//sll
				ALUControlD = 4'b0101; 					
				RegWriteD = 1'b1;  
			end						
			{7'b011_0011, 3'b101, 7'b000_0000}:	begin 										//srl
				ALUControlD = 4'b0110;	
				RegWriteD = 1'b1;  
			end
			{7'b011_0011, 3'b101, 7'b010_0000}:	begin										//sra
				ALUControlD = 4'b0111;		
				RegWriteD = 1'b1;
			end
			{7'b011_0011, 3'b010, 7'b000_0000}:	begin										//slt
				ALUControlD = 4'b1000;				
				RegWriteD = 1'b1;
			end			
			{7'b011_0011, 3'b011, 7'b000_0000}:	begin										//sltu
				ALUControlD = 4'b1001;			
				RegWriteD = 1'b1;
			end
			
			/*{7'b001_0011, 3'b000, 7'bxxx_xxxx}:												//addi		I-type (W/ no memory)
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
*/
			default:													// Undefined instruction
		endcase
	end

endmodule