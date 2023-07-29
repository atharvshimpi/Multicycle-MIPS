/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/

`include "Dff.v"
`include "PC.v"
`include "memory.v"
`include "IR.v"
`include "MDR.v"
`include "regFile.v"
`include "A.v"
`include "B.v"
`include "ALUOut.v"
`include "mux2_1_Data.v"
`include "mux4_1_Data.v"
`include "muxRegAddr.v"
`include "signExtn.v"
`include "ALU.v"
`include "controller.v"

module MIPS_multiCycle(input clk, input reset, output [31:0] result);
	wire aluSrcA;
    wire [1:0] aluSrcB;

	wire zero;
	wire memRead;
    wire memWr;
	wire irWr;
    wire iorD;
	wire regWr;
    
    wire memToReg;
	wire [1:0] regData;
	wire regDest;
    wire pcWr;
    wire bne;
	wire pcSrc;
	
	wire [4:0] rd;
    wire [4:0] memAddr;
    wire [31:0] irOut;
    wire [31:0] memOut;
    wire [31:0] mdrOut;
	wire [31:0] writeData;
	wire [31:0] regRs; //input to A
	wire [31:0] regRt; //input to B
	wire [31:0] Aout;
	wire [31:0] Bout;
	wire [31:0] signExtOut;
	wire [31:0] pcIn;
	wire [31:0] pcOut;
	wire [31:0] aluIn1;
	wire [31:0] aluIn2;
	wire [31:0] aluOut;
    
    wire [1:0] aluOp;
    wire [5:0] funct;
    wire [3:0] ALUContrl; 
    
	//WRITE YOUR CODE HERE, NO NEED TO DEFINE NEW VARIABLES
    controlCircuit cc(clk, reset, irOut[31:26], irOut[5:0], pcWr, pcSrc, bne, irWr, memRead, regWr, regDest, memToReg, aluSrcA, aluSrcB, aluOp, zero, memWr, iorD);
	Memory mem(clk, reset, memAddr, memRead, memWr, Bout, memOut);
	registerFile register_file(clk, reset, regWr, irOut[25:21], irOut[20:16], rd, writeData, regRs, regRt);

	// pc
	PC_Reg pc(clk, reset, (pcWr | (bne & ~zero)), pcIn, pcOut);
	// ir
    IR_Reg ir(clk, reset, irWr, memOut, irOut);
    // mdr
    MDR_Reg mdr(clk, reset, 1'b1, memOut, mdrOut);
	// A
    A_Reg A(clk, reset, 1'b1, regRs, Aout);
	// B
    B_Reg B(clk, reset, 1'b1, regRt, Bout);
    // ALU Out
    ALUOut_Reg AluOut(clk, reset, 1'b1, aluOut, result); 

    // m1 
    mux2to1_5bits m1(pcOut[6:2], result[6:2], iorD, memAddr);
    // m2        
    mux2to1_5bits m2(irOut[20:16], irOut[15:11], regDest, rd);    
    // m3
    mux2to1_32bits m3(result, mdrOut, memToReg, writeData);
    // m4
    mux2to1_32bits m4(pcOut, Aout, aluSrcA, aluIn1);
    // m5
    mux4to1_32bits m5(Bout, 32'd4, signExtOut, signExtOut << 2, aluSrcB, aluIn2);
	// m6
    mux2to1_32bits m6(aluOut, result, pcSrc, pcIn);

	signExt16to32 sign_ext(irOut[15:0], signExtOut);
    aluCtrl ALUCtrl(aluOp, irOut[5:0], ALUContrl);
	alu alu1(aluIn1, aluIn2, ALUContrl, aluOut, zero);	
endmodule

