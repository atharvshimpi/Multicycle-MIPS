/*##########################################################################################
Note: Please don’t upload the assignments, template file/solution and lab. manual on GitHub or others public repository. 
Kindly remove them, if you have uploaded the previous assignments. 
It violates the BITS’s Intellectual Property Rights (IPR).
*******************************************************************************************/

//The Dff_Reg will be used for making the pipeline registers

module Dff_Reg(input clk, input reset, input regWrite, input d, output reg q);
    //WRITE YOUR CODE HERE, NO NEED TO DEFINE NEW VARIABLES
    always @(reset)
        if (reset == 1'b1)
            q <= 0;
    always @(posedge clk) 
        if (reset == 1'b0 && regWrite == 1'b1)
            q <= d; 
endmodule

	 
