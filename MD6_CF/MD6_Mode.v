`include "parameters.vh"

module MD6_Mode
#( 	
	// Because the implementation is only of a single cf, those parameters will be constants
	parameter l = 8'd1,       
	parameter z_end = 4'd1,
	parameter index =56'd0
 )
(
  input  wire 			     		 clk, 	 
  input  wire				 		 reset,
  input  wire 				 		 enable,
  input  wire  [`wi*(64*`w)-1:0] 	 M,	 			 // The message to be hashed (mandatory)
  input	 wire  [11:0] 		 		 d,  			 // Message digest length desired, in bits (mandatory). 224|256|384|512
  input  wire  [8*`w-1:0]    		 K,  			 // Key (optional) default is 0
  input  wire  [7:0]         		 keylen, 
  input  wire  [7:0]   		 		 L,  			 // Mode control (optional) default is 64 full parallel
  input	 wire  [11:0] 		 		 r,  			 // Nnumber of rounds. max default is 168 (40+512/4)
  input  wire  [15:0]        		 padding_zero_M, // The padding zero for the massage. total of 4096 bits in a single cf
  input  wire  [7:0]                 index_padd,     //The index of last cf at the first level
		 
  output reg   [511:0]   	 		 D, 			 // Final hash value of M
  output wire 						 done_MD6		 // done indicator. will turn on a LED.
	
);
	
	wire  [`c*`w-1:0]   		 D_i;
	
	always@ (*)//MD6 is defined in a big-endian way: the high-order byte of a word is defined
		case(d)//to be the “first” (leftmost) byte.
			224 : D[511:512-224] <= {D_i[`c*`w-225:`c*`w-256],D_i[`c*`w-129:`c*`w-192],D_i[`c*`w-65:`c*`w-128],D_i[`c*`w-1:`c*`w-64]};
			256 : D[511:512-256] <= {D_i[`c*`w-193:`c*`w-256],D_i[`c*`w-129:`c*`w-192],D_i[`c*`w-65:`c*`w-128],D_i[`c*`w-1:`c*`w-64]};
			384 : D[511:512-384] <= {D_i[`c*`w-321:`c*`w-384],D_i[`c*`w-257:`c*`w-320],D_i[`c*`w-193:`c*`w-256],D_i[`c*`w-129:`c*`w-192],D_i[`c*`w-65:`c*`w-128],D_i[`c*`w-1:`c*`w-64]};
			512 : D[511:512-512] <= {D_i[`c*`w-449:`c*`w-512],D_i[`c*`w-385:`c*`w-448],D_i[`c*`w-321:`c*`w-384],D_i[`c*`w-257:`c*`w-320],D_i[`c*`w-193:`c*`w-256],D_i[`c*`w-129:`c*`w-192],D_i[`c*`w-65:`c*`w-128],D_i[`c*`w-1:`c*`w-64]};
			default : D <= 0;
		endcase	
	
	cf			    T1 
	(
		.clk(clk),
		.reset(reset),
		.enable(enable),
		.index(index),
		.index_padd(index_padd),
		.level(l),
		.Level(L),
		.z_end(z_end),
		.rounds(r),
		.d(d),
		.Message(M),
		.padding_zero_M(padding_zero_M),
		.Key(K),
		.keylen(keylen),
		.done(done_MD6),
		.C(D_i)
	);
endmodule
