`include "parameters.vh"

module top_N
(
  input  wire  [55:0]   	 index,  
  input  wire  [7:0]   		 level,  
  input  wire  [7:0]   		 Level,  // Max level
  input  wire  [3:0]   		 z_end,  
  input	 wire  [11:0] 		 r,	     // rounds
  input	 wire  [11:0] 		 d,      // length of desired hash
  input  wire  [64*`w-1:0]   M_in,
  input  wire  [8*`w-1:0]    K, 
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
		.K_out(K_to_N),
		.keylen(keylen_to_V)
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
		.M(M_in),
		.B_out(B_to_N),
		.p(p_to_V)
	);
	
	N			T6 
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
	output	wire [8*`w-1:0]  K_out,
	output  wire [7:0]	     keylen
);

assign  K_out  = K_in;//`rotate_key(K_in);
assign  keylen = (`clog2(`rotate_key(K_in)))/8; //reducing 46 because of unwated 46 bits not related to Key.

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
	
	assign r_param = 40 + d/4;
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
	output wire [64*`w-1:0] B_out,
	output wire [15:0] 		p
	
);
	assign B_out  = `rotate(M);
	assign p  =	`padding(M);
	
endmodule

module N   	        
(
  input  wire [(15*`w-1):0]	 Q, // ווקטור קבוע
  input  wire [(8*`w-1) :0]  K, // מפתח
  input  wire [(1*`w-1) :0]  U, // מזהה צומת ייחודי
  input  wire [(1*`w-1) :0]  V, // מילת שליטה
  input  wire [(64*`w-1):0]  B, // עומק נתונים
  output wire [(89*`w-1):0]  N_out
	
);

	assign N_out[(15*`w-1):0]    = Q;
	assign N_out[23*`w-1:15*`w]  = K;
	assign N_out[24*`w-1:23*`w]  = U;
	assign N_out[25*`w-1:24*`w]  = V;
	assign N_out[89*`w-1:25*`w]  = B;

endmodule
