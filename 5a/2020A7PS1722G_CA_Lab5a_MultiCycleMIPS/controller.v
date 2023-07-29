/*###################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
It violates the BITS’s Intellectual Property Rights (IPR).
************************************************************************************/
//MIPS's instruction's Opcode

`define ADDI    6'd8
`define LW      6'd35
`define SW      6'd43
`define BNE     6'd5
`define ADD     6'd0

module controlCircuit(input clk, input reset, input [5:0] opcode, input [5:0] funct, output reg pcWr, output reg  pcSrc,
                             output reg bne, output reg irWr, output reg memRead, output reg regWr, output reg regDest, 
                             output reg  memToReg, output reg aluSrcA, output reg [1:0] aluSrcB, output reg [1:0] aluOp, 
                             output reg zero, output reg memWr, output reg iorD);
	// Write your code here
	reg [3:0] state;
	reg [3:0] nextstate;
    parameter T0 = 0, T1 = 1, T2 = 2, T3 = 3, T4 = 4, T5 = 5, T6 = 6, T7 = 7, T8 = 8, T9 = 9;
	
	//WRITE YOUR CODE HERE, NO NEED TO DEFINE NEW VARIABLES
	always @ (posedge clk, posedge reset) 
    begin
        case (reset)
            1'b0: state <= nextstate;
            1'b1: state <= T0;
        endcase
    end

    always @ (opcode, state) 
        begin
            // Default Conditions
            pcWr = 0;
            pcSrc = 1; // Why so?
            bne = 0;
            irWr = 0;
            memRead = 0;
            regWr = 0;
            regDest = 0;
            memToReg = 0;
            aluSrcA = 0;
            aluSrcB = 2'b00;
            aluOp = 2'b00;
            zero = 0;
            memWr = 0;
            iorD = 0;

            case (state)
                // fetch
                T0: 
                    begin
                        nextstate = T1;
                        pcWr = 1;
                        irWr = 1;
                        memRead = 1;
                        aluOp = 2'b00;
                        pcSrc = 0;
                        aluSrcB = 2'b01;
                    end

                // decode
                T1:
                    begin
                        aluSrcB = 2'b11;
                        case(opcode)
                            `ADD: nextstate = T2;
                            `ADDI: nextstate = T3;
                            `LW: nextstate = T3;
                            `SW: nextstate = T3;
                            `BNE: nextstate = T4;        
                        endcase
                    end
                
                T3:
                    begin
                        aluSrcA = 1;
                        aluSrcB = 2'b10;
                        case(opcode)
                            `LW: nextstate = T6;
                            `SW: nextstate = T7; 
                            `ADDI: nextstate = T8;
                        endcase
                    end

                // LW
                T6:
                    begin
                        iorD = 1;
                        memRead = 1;
                        nextstate = T9;
                    end

                T9: 
                    begin
                        memToReg = 1;
                        regWr = 1;
                        nextstate = T0;
                    end

                // SW
                T7:
                    begin
                        iorD = 1;
                        memWr = 1;
                        nextstate = T0;
                    end

                // ADD
                T2:
                    begin
                        aluSrcA = 1;
                        nextstate = T5;
                    end
                
                T5:
                    begin
                        regDest = 1;
                        regWr = 1;
                        nextstate = T0;
                    end

                // BNE
                T4:
                    begin
                        aluSrcA = 1;
                        aluOp = 2'b01;
                        bne = 1;
                        nextstate = T0;
                    end

                // ADDI
                T8:
                    begin
                        regWr = 1;
                        nextstate = T0;
                    end
            endcase
        end
endmodule