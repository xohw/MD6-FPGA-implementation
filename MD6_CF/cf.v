`include "parameters.vh"
//
//This module is the (single) compression function (cf)
//It is a top of 5 modules
//1) N - a bus of 89 words. (64 words of massage, control word, identity of cf words, 8 key words and 15 words of constatns)
//2) S - "constants". Are calculated according to the rounds order. Hence, each round has its own "constant". coming from RAM.
//3) rom_rshift_lshift - R&L shifts were determined by the MD6 algo designer. 
//4) A_steps - computation of 16 steps (16 words)
//5) A_arrangement - A window of 89 words which is shifted by 16 words every cycle time
module cf
(
  input  wire 				 clk,
  input  wire 				 reset,
  input  wire 				 enable,
  input  wire  [55:0]   	 index, 						// Curent index
  input  wire  [7:0]         index_padd,   				 	// The index of last cf at the first level
  input  wire  [7:0]   		 level,  						// Current level 
  input  wire  [7:0]   		 Level,  					
  input  wire  [3:0]   		 z_end,  						// Last cf indicator 
  input	 wire  [11:0] 		 rounds,	     						
  input	 wire  [11:0] 		 d,      						// Length of desired hash
  input  wire  [64*`w-1:0]   Message,
  input  wire  [15:0]        padding_zero_M,				// The padding zero for the massage. total of 4096 bits in a single cf
  input  wire  [8*`w-1:0]    Key,
  input  wire  [7:0]         keylen, 
  output wire  				 done,
  output wire  [`c*`w-1:0]	 C								// Compressed message
);
	
// To "A_computation_loop" module	
	wire [168*`w-1:0]			S;
    wire [16*`b-1 : 0]		 	rshift;
	wire [16*`b-1 : 0] 			lshift;
	wire [11:0]					R;
    wire [`n*`w-1:0]			A;
	
// To "A_iterative" module
	wire [`n*`w-1:0] 			N;
	wire [`c*`w-1:0] 			A_steps;
	wire [11:0] 				A_round_i; 					// A batch of 16 words index
	wire 						N_to_A_en;
	wire 						iterative_en;
	wire 						A_shift_stop;


	
	assign R = N[24*`w + 59: 24*`w +48]; 					 // The "r" parameter is taken from the control word - "V".
	
	assign C = (Message != 0) ? A[(`n*`w-`c*`w) +:`c*`w] : 0;   // If no massage has been arrived, the cf output should be zero.

	N					T1 
	(
		.index(index),
		.index_padd(index_padd),
		.level(level),
		.Level(Level),
		.z_end(z_end),
		.r(rounds),
		.d(d),
		.Message(Message),
		.padding_zero_M(padding_zero_M),
		.K(Key),
		.keylen(keylen),
		.N(N)
	);

	S					T2 
	(

		.S_out(S)
	);
	
	rom_rshift_lshift	T3
	(

		.rshift(rshift),
		.lshift(lshift)
	);
	
	
	A_computation_loop		T4 
	(
		.clk(clk),
		.reset(reset),
		.enable(enable),
		.r(R),      
		.S(S),
		.R_shift(rshift),
		.L_shift(lshift),
		.A(A),
		.N_to_A_en(N_to_A_en),
		.iterative_en(iterative_en),
		.A_round_i(A_round_i),
		.A_steps(A_steps),
		.done(done),
		.A_shift_stop(A_shift_stop)
	);
	
	A_iterative		T5 
	(
		.clk(clk),
		.N_to_A_en(N_to_A_en),
		.iterative_en(iterative_en),
		.done(A_shift_stop),
		.A_round_i(A_round_i),
		.N(N),
		.A_steps(A_steps),
		.A_out(A)
	);
	
endmodule