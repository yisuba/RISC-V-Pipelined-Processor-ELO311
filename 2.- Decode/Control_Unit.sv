`timescale 1ns / 1ps

// Control_Unit
////// Solo estan relativamente bien definidas las instrucciones R-type
/// Funcionamiento no optimizado para srli y srai (problema con ecall y ebreak)
////////////////////////////

module Control_Unit(
	input logic [2:0] funct3, 
	input logic [6:0] op, funct7,
	
	output logic RegWriteD, MemWriteD, JumpD, BranchD, AluSrcD,	JalrD,	
	output logic [1:0] ResultSrcD, StoreTypeD,
	output logic [2:0] ImmSrcD,	LoadTypeD, BranchTypeD,				//NoBranch -> 3'h2	
	output logic [3:0] ALUControlD									
);
   
//PROTOTIPO MIO (POCO CLARO)
    always_comb begin
        logic [6:0] imm;
               
        case (op)
        // R-type  
            7'b011_0011: begin							
                RegWriteD = 1'b1;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchD = 1'b0;
                AluSrcD = 1'b0;
                ImmSrcD = 3'bx;
                LoadTypeD = 3'bx; 
				StoreTypeD = 4'bx;
				BranchTypeD = 3'h2; 
				JalrD = 1'b0;
                
                case(funct3) 							//Que instruccion del tipo R?
                    3'h0: begin
                        if (funct7 == 7'h00)			
                            ALUControlD = 4'b0000;		// add
                        else if (funct7 == 7'h20)						
                            ALUControlD	= 4'b0001;		// sub
                        else 
                            ALUControlD = 4'bx;
                    end
                    3'h4: ALUControlD = 4'b0010;		// xor
                    3'h6: ALUControlD = 4'b0011;		// or
                    3'h7: ALUControlD = 4'b0100;		// and
                    3'h1: ALUControlD = 4'b0101;		// sll
                    3'h5: begin
                        if (funct7 == 7'h00)		    // srl
                            ALUControlD = 4'b0110;
                        else if (funct7 == 7'h20)	    // sra
                            ALUControlD = 4'b0111;
                        else 
                            ALUControlD = 4'bx;
                          end
                    3'h2: ALUControlD = 4'b1000;		// slt
                    3'h3: ALUControlD = 4'b1001;		// sltu
                    default: ALUControlD = 4'bx;
                endcase
            end          
            
            
        // I-type (W/ no memory)		***SLLI, SRLI, SRAI con imm invertido (?         
            7'b001_0011: begin							
                RegWriteD = 1'b1;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchD = 1'b0;
                AluSrcD = 1'b1;
                ImmSrcD = 3'b000;
                LoadTypeD = 3'bx; 
				StoreTypeD = 4'bx;               
				BranchTypeD = 3'h2; 
				JalrD = 1'b0;	
				                
                case(funct3)							//Que instruccion del tipo I? 
                    3'h0: ALUControlD = 4'b0000;		// addi							
                    3'h4: ALUControlD = 4'b0010;		// xori 
                    3'h6: ALUControlD = 4'b0011;		// ori
                    3'h7: ALUControlD = 4'b0100;		//andi
                    3'h1: ALUControlD = 4'b0101;		//slli* 
                    3'h5: begin
                            imm = {funct7[0], funct7[1], funct7[2], funct7[3], funct7[4], funct7[5], funct7[6]};
                            if (imm == 7'h00)				//srli*
                                ALUControlD = 4'b0110;
                            else if (imm == 7'h20)			//srai*
                                ALUControlD = 4'b0111;
                            else 
                                ALUControlD = 4'bx;
                          end
                    3'h2: ALUControlD = 4'b1000; 		//slti
                    3'h3: ALUControlD = 4'b1001;		//sltiu
                    default: ALUControlD = 4'bx;
                endcase
            end


        // I-type (W/ memory (load))	
            7'b000_0011: begin							
                RegWriteD = 1'b1;
                ResultSrcD = 2'b01;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchD = 1'b0;
                AluSrcD = 1'b1;
                ImmSrcD = 3'b000;
				ALUControlD = 4'b0000; //rd = M[rs1+imm]
				StoreTypeD = 4'bx;
				BranchTypeD = 3'h2; 
				JalrD = 1'b0;
				                
                case(funct3) 							//Que instruccion load?
                    3'h0: LoadTypeD = 3'b000; //lb
                    3'h1: LoadTypeD = 3'b001; //lh
                    3'h2: LoadTypeD = 3'b010; //lw
                    3'h4: LoadTypeD = 3'b011; //lbu
                    3'h5: LoadTypeD = 3'b100; //lhu
                    default: LoadTypeD = 3'bx;
                endcase
            end
            
            
        // S-type 						***    
            7'b010_0011: begin							
                RegWriteD = 1'b0;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b1;
                JumpD = 1'b0;
                BranchD = 1'b0;
                AluSrcD = 1'b1;
                ImmSrcD = 3'b001;
                ALUControlD = 4'b0000;
                LoadTypeD = 3'bx;
				BranchTypeD = 3'h2; 
				JalrD = 1'b0;
				                
                case(funct3) 							//Que instruccion store? 
                    3'h0: StoreTypeD = 2'b00; //sb
                    3'h1: StoreTypeD = 2'b01; //sh
                    3'h2: StoreTypeD = 2'b10; //sw
                    default: StoreTypeD = 2'bx;
                endcase
            end
 

        // B-type						***           
            7'b110_0011: begin							
                RegWriteD = 1'b0;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchD = 1'b1;
                AluSrcD = 1'b0;
                ImmSrcD = 3'b010;
                LoadTypeD = 3'bx;
                StoreTypeD = 2'bx;
 				JalrD = 1'b0;
               
                case(funct3)					//Que instruccion branch? 		
                    3'h0: begin                     // beq 
                            BranchTypeD = 3'h0;
                            ALUControlD = 4'b0001;
                          end    
                    3'h1: begin                     // bne 
                            BranchTypeD = 3'h1;
                            ALUControlD = 4'b0001;
                          end
                    3'h4: begin                     // blt 
                            BranchTypeD = 3'h4;
                            ALUControlD = 4'b1000;
                          end
                    3'h5: begin                     // bge 
                            BranchTypeD = 3'h5;
                            ALUControlD = 4'b1000;
                          end
                    3'h6: begin                     // bltu 
                            BranchTypeD = 3'h6;
                            ALUControlD = 4'b1001;
                          end 
                    3'h7: begin                     // bgeu 
                            BranchTypeD = 3'h7;
                            ALUControlD = 4'b1001;
                          end 
                    default: begin
                                BranchTypeD = 3'h2;
                                ALUControlD = 4'hx;
                             end
                endcase
            end
        
        
        // J-type (jal)					***            
            7'b110_1111: begin							
                RegWriteD = 1'b1;
                ResultSrcD = 2'b10;
                MemWriteD = 1'b0;
                JumpD = 1'b1;
                BranchD = 1'b0;
                AluSrcD = 1'bx;
                ImmSrcD = 3'b100;
                ALUControlD = 4'hx;
                LoadTypeD = 3'bx;
                StoreTypeD = 2'bx;           
                BranchTypeD = 3'h2; 
				JalrD = 1'b0;
            end
  
          
        // I-type (jalr) 				***            
            7'b110_0111: begin							
                RegWriteD = 1'b1;
                ResultSrcD = 2'b10;
                MemWriteD = 1'b0;
                JumpD = 1'b1;
                BranchD = 1'b0;
                AluSrcD = 1'b1;
                ImmSrcD = 3'b000;
                ALUControlD = 4'hx;
                LoadTypeD = 3'bx;
                StoreTypeD = 2'bx;           
                BranchTypeD = 3'h2;                 
				JalrD = 1'b1;
            end

/*        
        // U-type (lui) 				***            
            7'b011_0111: begin							
                RegWriteD = 1'b1;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchD = 1'b0;
                AluSrcD = 1'b1;
                ImmSrcD = 3'b011;
                ALUControlD = 4'hx; **
                LoadTypeD = 3'bx;
                StoreTypeD = 2'bx;           
                BranchTypeD = 3'h2;                 
				JalrD = 1'bx;            
            end


        // U-type (auipc)				***            
            7'b001_0111: begin							
                RegWriteD = 1'b1;
                ResultSrcD = 2'b00;
                MemWriteD = 1'b0;
                JumpD = 1'b0;
                BranchTypeD = 3'h2; 
                AluSrcD = 1'b1;
                ImmSrcD = 3'b011;
            
            end
 
 
        // I-type (ecall / eberak)		***Transfer control to OS/debugger           
            7'b111_0011: begin							
                RegWriteD = 1'b1;
                ResultSrcD = 2'b00;
                MemWriteD = 1'bx;
                JumpD = 1'b0;
                BranchTypeD = 3'h2; 
                AluSrcD = 1'b1;
                ImmSrcD = 3'bx;
            end
      */      
            default: begin
                        RegWriteD = 1'b0;
                        ResultSrcD = 2'b00;
                        MemWriteD = 1'b0;
                        JumpD = 1'b0;
                        BranchD = 1'b0;
                        AluSrcD = 1'bx;
                        ImmSrcD = 3'bx;
                        LoadTypeD = 3'bx;
                        StoreTypeD = 2'bx;
                        BranchTypeD = 3'h2;
                        ALUControlD = 4'bx;
       			      	JalrD = 1'b0;
                     end 									
		endcase
    end
endmodule