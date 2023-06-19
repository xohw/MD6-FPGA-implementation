`include "parameters.vh"

module N
(
  input  wire  [55:0]   	 index, 
  input  wire  [7:0]         index_padd,
  input  wire  [7:0]   		 level,  
  input  wire  [7:0]   		 Level,  // Max level
  input  wire  [3:0]   		 z_end,  
  input	 wire  [11:0] 		 r,	     // rounds
  input	 wire  [11:0] 		 d,      // length of desired hash
  input  wire  [64*`w-1:0]   Message,
  input  wire  [15:0]        padding_zero_M,
  input  wire  [8*`w-1:0]    K,
  input  wire  [7:0]         keylen,  
  output wire  [`n*`w-1:0]   N
	
);
	wire [15*`w-1:0] Q_to_N;	
	wire [8*`w-1:0]  K_to_N;	
	wire [7:0]       keylen_to_V;
	wire [`w-1:0]    U_to_N;	
	wire [15:0]      p_to_V;
	wire [`w-1:0] 	 V_to_N;
	wire [64*`w-1:0] B_to_N;
	
	
	
	Q			T1 
	(
		.Q_out(Q_to_N)
	);
	
	K			T2
	(
		.K_in(K),
		.keylen(keylen),
		.K_out(K_to_N),
		.key_len(keylen_to_V)
	);
	
	U			T3 
	(
		.l(level),
		.i(index),
		.U_out(U_to_N)
	);
	
	V			T4 
	(
		.r(r),
		.L(Level),
		.z(z_end),
		.p(p_to_V),
		.keylen(keylen_to_V),
		.d(d),
		.V_out(V_to_N)
	);
	
	B			T5 
	(
		.M(Message),
		.padding_zero_M(padding_zero_M),
		.L(Level),
		.z_end(z_end),
		.level(level),
		.index(index),
		.index_padd(index_padd),
		.B_out(B_to_N),
		.p(p_to_V)
	);
	
	N_arrangement	T6 
	(
		.Q(Q_to_N),
		.K(K_to_N),
		.U(U_to_N),
		.V(V_to_N),
		.B(B_to_N),
		.N_out(N)
	);
	
endmodule

module Q
(
	output wire	[(15*`w-1):0] Q_out
);

assign Q_out = `Q_array;
 
endmodule 

module K
(
	input	wire [8*`w-1:0]  K_in,
	input   wire [7:0]       keylen,
	output	wire [8*`w-1:0]  K_out,
	output  wire [7:0]	     key_len
);

assign  K_out  = K_in;
assign  key_len = keylen; 

endmodule

module U   	        
(
	input  wire [7:0]	 l, //level
    input  wire	[55:0] 	 i, //index
	output wire [`w-1:0] U_out
	
);
	
	assign U_out[63:56]     = l; 
	assign U_out[55:0]  	= i;

endmodule

module V   	        
(      
	input  wire [11:0] 	 r,
	input  wire [7:0] 	 L,
	input  wire [3:0] 	 z,
	input  wire [15:0] 	 p,
	input  wire	[7:0] 	 keylen,
	input  wire [11:0] 	 d,
	output wire [`w-1:0] V_out
	
);
	wire [11:0] 		 R;
	wire [11:0]			 r_param;
	
	assign r_param = 40 + d/4;          //The deafult value equals to 40 + r/4
	assign R = (r==0) ? r_param : r;
	
	assign V_out[63:60]  = 4'b0;
	assign V_out[59:48]  = R;
	assign V_out[47:40]  = L;
	assign V_out[39:36]  = z;
	assign V_out[35:20]  = p;
	assign V_out[19:12]  = keylen;
	assign V_out[11:0]   = d;
	
endmodule

module B   	        
( 
	input  wire [64*`w-1:0]	M,
	input  wire [15:0]      padding_zero_M,
	input  wire [7:0]       L,
	input  wire [3:0]       z_end,
	input  wire [7:0]       level,
	input  wire [55:0]      index,
	input  wire [7:0]       index_padd,
	output wire [64*`w-1:0] B_out,
	output wire [15:0] 		p
	
);
	assign B_out  = M;
	assign p  =	(z_end&&!L) ? padding_zero_M : (level==1&&index==index_padd&&(L>0)) ? padding_zero_M : (M[64*`w-1:16*`w]==0) ? 3072 : (M[64*`w-1:32*`w]==0) ? 2048 : (M[64*`w-1:48*`w]==0) ? 1024 : 0;
	
		//if it's SEQ mode the padding is at the end. (*it is written deliberately as shown in order to emphasize the following conditions:*)
		//else if it's PAR mode, the padding is at the last cf (highest index)
		//else if massage us zero partially padding accordingly
		//else , no need to pad by zero
	
endmodule

module N_arrangement   	        
(
  input  wire [(15*`w-1):0]	 Q, // constants 
  input  wire [(8*`w-1) :0]  K, 
  input  wire [(1*`w-1) :0]  U, // index and level word
  input  wire [(1*`w-1) :0]  V, // control word
  input  wire [(64*`w-1):0]  B, // block of data 
  output wire [(89*`w-1):0]  N_out
	
);

	assign N_out[(15*`w-1):0]    = Q;
	assign N_out[23*`w-1:15*`w]  = K;
	assign N_out[24*`w-1:23*`w]  = U;
	assign N_out[25*`w-1:24*`w]  = V;
	assign N_out[89*`w-1:25*`w]  = B;

endmodule
