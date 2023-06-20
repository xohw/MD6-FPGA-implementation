`include "parameters.vh"
//
//This module is responsible for "Iterative implementation"
//Each "A_round_i" is actually a round and in other words a batch of 16 "words" (16*64bits)
//Every new computation (round) it uses the last ~89 words, and therfore the compression function
// could be iterative.  
//
//
module A_iterative
(
	input  wire   				clk,
	input  wire   				N_to_A_en,     // Enable to insert "N" (first 89 words) into "A" (A vector in which incluse the result of the computation.
	input  wire   				iterative_en,  // Enable for indicating the iterative operation. 
	input  wire 				done,
	input  wire	[11:0]			A_round_i,     // The current number of a round (rounds index)
	input  wire [`n*`w-1:0]		N,
	input  wire [`c*`w - 1 : 0] A_steps,       // 16 words computation result.
	output reg  [`n*`w-1:0] 	A_out          // going to A_steps module for genrating new A_steps in the next round.

); 

always@(posedge clk)
begin
	if (N_to_A_en)
		A_out <= N;
	if (((0<A_round_i&&A_round_i<`r)||iterative_en)&&!done)
		A_out <= {A_steps,A_out[`n*`w -1:`c*`w]};
end

endmodule