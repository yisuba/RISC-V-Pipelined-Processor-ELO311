`timescale 1ns / 1ps

module tb_Fetch_Stage;
    logic clk, rst;
    logic PCSrcE, StallF;
    logic [31:0] PCTargetE;
    logic [31:0] PCPlus4F;
    logic [31:0] PCF_postff, InstrF;

    Fetch_Stage DUT(
        .clk(clk),
        .rst(rst),
        .PCSrcE(PCSrcE),
        .StallF(StallF),
        .PCTargetE(PCTargetE),
        .PCPlus4F(PCPlus4F),
        .PCF_postff(PCF_postff),
        .InstrF(InstrF)
    );

    always #5 clk = ~clk; // Generador de clk cycle (ciclo de 10ns -> 100MHz)

    /* Proceso de prueba:	- always #5 clk = ~clk; cada 5[ns] cambiara de canto, lo que simula el reloj real de la FPGA y la normalidad de los sistemas 
							- #10 para un ciclo completo del clk */
   
   initial begin			//Inicialización del tb (rst = 1 para inicializar) -> Aplicar en el resto de tb
   
        clk = 0;
        rst = 1;       
        PCSrcE = 0;
        StallF = 0;
        PCTargetE = 32'h00000000;
        
        #10; //10ns - negedge
        rst = 0;  
		if (PCF_postff == 32'h0000_0000) $display("PC inicializado correctamente. Counter: %h. Instruccion: %h", PCF_postff, InstrF);
        
		#10; //20ns
        if (PCF_postff == 32'h0000_0004) $display("PC avanza +4 correctamente. Counter: %h. Instruccion: %h", PCF_postff, InstrF);
       
	   #10; //30ns
        if (PCF_postff == 32'h00000008) $display("PC sigue avanzando correctamente. Counter: %h. Instruccion: %h", PCF_postff, InstrF);
        StallF = 1;
		
        #10; //40ns
        if (PCF_postff == 32'h00000008) $display("Stall mantiene el PC. Counter: %h. Instruccion: %h", PCF_postff, InstrF);
        StallF = 0;
        PCSrcE = 1;
        PCTargetE = 32'h00000020;  // Caso en que salta a 0x20 y MUX elige input de Execute
        
		#10; //50ns
        if (PCF_postff == 32'h00000020) $display("PC salta correctamente (esperando 0x20). Counter: %h. Instruccion: %h", PCF_postff, InstrF);
        PCSrcE = 0;	//MUX vuelve a elegir desde PC+4
        
		#10; //60ns
        if (PCF_postff == 32'h00000024) $display("PC avanza +4 correctamente despues del salto (esperado 0x24). Counter: %h. Instruccion: %h", PCF_postff, InstrF);
        $finish;
    end	
endmodule
