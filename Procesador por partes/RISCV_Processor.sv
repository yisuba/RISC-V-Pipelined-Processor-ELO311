
Instruction_Fetch_Stage IF(
	.clk(clk),
	.rst(rst),
	.PCSrcE(),
	.StallF(),
	.PCTargetE(),
	.PCPlus4F(),
	.PCF_postff(),
	.InstrF()
);	

	logic [31:0] InstrD, PCD, PCPlus4D;
	always_ff @(posedge clk or posedge rst) begin			// FF de salida de la Instruction_Fetch
		if(rst) begin
			InstrD <= 32'b0;
			PCD <= 32'b0;
			PCPlus4D <= 32'b0;
			end
		else if(!StallD) begin
			InstrD <= InstrF;
			PCD <= PCF_postff;
			PCPlus4D <= PCPlus4F;
			end
	end


/////////////////////////////////////////////////////////////////////////
	input logic clk, rst,
    input logic PCSrcE,
    input logic [31:0] PCTargetE,
    inout logic [31:0] PCPlus4F,
    output logic [31:0] PCF_postff
	

