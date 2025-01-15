
Instruction_Fetch IF(
	.clk(clk),
	.rst(rst),
	.PCSrcE(),
	.PCTargetE(),
	.PCPlus4F(),
	.PCF_postff(),

);	

   input logic clk, rst,
    input logic PCSrcE,
    input logic [31:0] PCTargetE,
    inout logic [31:0] PCPlus4F,
    output logic [31:0] PCF_postff