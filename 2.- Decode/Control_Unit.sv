
// Control_Unit
////// Solo están relativamente bien definidas las instrucciones R-type
///// FALTA perfeccionar cada una de las instrucciones
///// slli, srli, srai tienen una convención inversa de imm (imm[5:11]), se cambi� para simular
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
	output logic [1:0] ResultSrcD, 
	output logic [2:0] ImmSrcD,							
	output logic [3:0] ALUControlD									
);

	logic [6:0] op;		
	assign op = InstrD[6:0];
	logic [2:0] funct3;
	assign funct3 = InstrD[14:12];
	logic [6:0] funct7;
	assign funct7 = InstrD[31:25];
    logic [11:0] imm;
    assign imm = InstrD[31:20];
   
//PROTOTIPO MIO (POCO CLARO)
    always_comb begin
        case (op) 
            7'b011_0011: begin							// R-type
                RegWriteD = 1'b1;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchD = 1'b0;
                AluSrcD = 1'b0;
                ImmSrcD = 3'bxxx;
                
                case(funct3) 							//Qué instrucción del tipo R?
                    3'h0: begin
                        if (funct7 == 7'h00)			
                            ALUControlD = 4'b0000;		// add
                        else if (funct7 == 7'h20)						
                            ALUControlD	= 4'b0001;		// sub
                    end
                    3'h4: ALUControlD = 4'b0010;		// xor
                    3'h6: ALUControlD = 4'b0011;		// or
                    3'h7: ALUControlD = 4'b0100;		// and
                    3'h1: ALUControlD = 4'b0101;		// sll
                    3'h5: begin
                        if (funct7 ==7'h00)		// srl
                            ALUControlD = 4'b0110;
                        else if (funct7 == 7'h20)						// sra
                            ALUControlD = 4'b0111;
                    end
                    3'h2: ALUControlD = 4'b1000;		// slt
                    3'h3: ALUControlD = 4'b1001;		// sltu
                endcase
            end
            
            7'b001_0011: begin							// I-type (W/ no memory)		***CORREGIR SLLI, SRLI, SRAI****
                RegWriteD = 1'b1;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchD = 1'b0;
                AluSrcD = 1'b1;
                ImmSrcD = 3'b000;
                
                case(funct3)							//Qué instrucción del tipo I? 
                    3'h0: ALUControlD = 4'b0000;		// addi							
                    3'h4: ALUControlD = 4'b0010;		// xori 
                    3'h6: ALUControlD = 4'b0011;		// ori
                    3'h7: ALUControlD = 4'b0100;		//andi
                    3'h1: ALUControlD = 4'b0101;		//slli* 
                    3'h5: begin
                                if(imm[11:5] == 7'h00)				//srli*
                                    ALUControlD = 4'b0110;
                                else if(imm[11:5] == 7'h20)			//srai*
                                    ALUControlD = 4'b0111;
                            end
                    3'h2: ALUControlD = 4'b1000; 		//slti
                    3'h3: ALUControlD = 4'b1001;		//sltiu
                endcase
            end
    	/*
            7'b000_0011: begin							// I-type (W/ memory (load))	***CORREGIR ImmSrcD***
                RegWriteD = 1'b1;
                ResultSrcD = 2'b01;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchD = 1'b0;
                AluSrcD = 1'b1;
                ImmSrcD = 3'b000;
				ALUControlD = 4'b0001; //rd = M[rs1+imm]
                
                case(funct3) 							//Qué instrucción load?
                    3'h0: ; //lb
                    3'h1: ; //lh
                    3'h2: ; //lw
                    3'h4: ; //lbu
                    3'h5: ; //lhu
                endcase
            end
            
            7'b010_0011: begin							// S-type 						***
                RegWriteD = 1'b1;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchD = 1'b0;
                AluSrcD = 1'b1;
                ImmSrcD = 3'b001;
                
                case(funct3) 							//Qué instrucción store? 
                    3'b000: //sb
                    3'b001: //sh
                    3'b010: //sw
                endcase
            end
            
            7'b110_0011: begin							// B-type						***
                RegWriteD = 1'b1;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchD = 1'b0;
                AluSrcD = 1'b1;
                ImmSrcD = 3'b010;
                
                case(funct3)							//Qué instrucción branch? 		
                    3'b000: // beq
                    3'b001: // bne
                    3'b100: // blt
                    3'b101: // bge
                    3'b110: // bltu
                    3'b111: // bgeu
                endcase
            end
            
            7'b110_1111: begin							// J-type (jal)					***
                RegWriteD = 1'b1;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchD = 1'b0;
                AluSrcD = 1'b1;
                ImmSrcD = 3'b100;
            
            end
            
            7'b110_0111: begin							// I-type (jalr) 				***
                RegWriteD = 1'b1;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchD = 1'b0;
                AluSrcD = 1'b1;
                ImmSrcD = 3'b000;
                
                if(funct3)
                    
            end
            
            7'b011_0111: begin							// U-type (lui) 				***
                RegWriteD = 1'b1;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchD = 1'b0;
                AluSrcD = 1'b1;
                ImmSrcD = 3'b011;
            
            end
            
            7'b001_0111: begin							// U-type (auipc)				***
                RegWriteD = 1'b1;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchD = 1'b0;
                AluSrcD = 1'b1;
                ImmSrcD = 3'b011;
            
            end
            
            7'b111_0011: begin							// I-type (ecall / eberak)		***Transfer control to OS/debugger
                RegWriteD = 1'b1;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchD = 1'b0;
                AluSrcD = 1'b1;
                ImmSrcD = 3'b000;
            end
            
            default: 									//default
	*/	endcase
    end
	
	
	
	
	
	
	
	
	
	
	
/*	always_comb begin
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

			default:													// Undefined instruction
		endcase
	end
*/
endmodule