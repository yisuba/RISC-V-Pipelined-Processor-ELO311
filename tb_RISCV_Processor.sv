`timescale 1ns / 1ps

module tb_RISCV_Processor;
	logic clk, rst;
	
	RISCV_Processor DUT(
		.clk(clk),
		.rst(rst)
	);
	
	always #5 clk = ~clk;
	
	initial begin
        clk = 0;
        
        #1 /*1ns*/ rst = 1;
        #2 /*3ns*/ rst = 0;
		#7; //10ns
        #200; //210ns
        #300; //500ns
        
        $finish;
	end
endmodule