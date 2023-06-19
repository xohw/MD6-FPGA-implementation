`include "parameters.vh"

module CF  	        
( 
  input  wire 		          clk,
  input  wire 		          reset,
  input  wire 				  enable,
  input  wire  [`n*`w-1:0]    N,
  input	 wire  [11:0] 		  r,			
  output reg 				  done,
  output wire  [`c*`w-1:0]    C             
	
);
	reg	[7:0]					j;
	reg [($clog2(`r*`c)-1):0]   t;
	reg [168*`w-1:0]			S = `S_array;
	reg	[16*`b-1:0]		   		rshift = `r_array;
	reg	[16*`b-1:0]		   		lshift = `l_array;
	reg [(`n+`r*`c)*`w-1:0]    	A;            		 //vector of words (64 bit each)
	reg [`c*`w-1:0]     		x;
	reg [1:0]			    	state;
	reg [11:0] 					R;                   // in oreder to get the abillty for dedault value for r in case r=0;
	reg [11:0]					r_param;

always @ (posedge clk) 	
begin	
	if (reset)
	begin
		state <= 0;
	end
	else
	begin
		case (state)
			0:
			begin
			t <= 0;
			j <= 0;	
			A[`n*`w-1:0]   <= N[`n*`w-1:0];
			A[`n*`w +:(`r*`c)*`w]   <= 0;
			done <= 0;
			r_param <= 40 + N[24*`w + 11: 24*`w]/4;
			if (enable)
				state <= 1;			
			end
			1:
			begin
			state <= 2;
			if (r==0)
				R <= r_param;
			else
				R <= r;
			end
			2:
			begin
				if ((j < R) && enable)
				begin		
					x[1*`w-1:0*`w] = S[(j)*`w+:`w] ^ A [(0+ t)*`w+:`w] ^ A [(`n + 0 - `t0 + t)*`w+:`w];
					x[1*`w-1:0*`w] = x[0*`w +:`w] ^ (A[(`n + 0 - `t1 + t)*`w+:`w] & A[(`n + 0 - `t2 + t)*`w+:`w]) ^ (A[(`n + 0 - `t3 + t)*`w+:`w] & A[(`n + 0 - `t4 + t)*`w+:`w]);
					x[1*`w-1:0*`w] = x[0*`w +:`w] ^ (x[0*`w +:`w] >> rshift[1*`b-1: 0*`b]);
					A[(`n + 0 +t)*`w +:`w] = x[0*`w+:`w] ^ (x[0*`w+:`w] << lshift[1*`b-1:0*`b]);

					x[2*`w-1:1*`w] = S[(j)*`w+:`w] ^ A [(1+ t)*`w+:`w] ^ A [(`n + 1 - `t0 + t)*`w+:`w];
					x[2*`w-1:1*`w] = x[1*`w +:`w] ^ (A[(`n + 1 - `t1 + t)*`w+:`w] & A[(`n + 1 - `t2 + t)*`w+:`w]) ^ (A[(`n + 1 - `t3 + t)*`w+:`w] & A[(`n + 1 - `t4 + t)*`w+:`w]);
					x[2*`w-1:1*`w] = x[1*`w +:`w] ^ (x[1*`w +:`w] >> rshift[2*`b-1: 1*`b]);
					A[(`n + 1 +t)*`w +:`w] = x[1*`w+:`w] ^ (x[1*`w+:`w] << lshift[2*`b-1:1*`b]);

					x[3*`w-1:2*`w] = S[(j)*`w+:`w] ^ A [(2+ t)*`w+:`w] ^ A [(`n + 2 - `t0 + t)*`w+:`w];
					x[3*`w-1:2*`w] = x[2*`w +:`w] ^ (A[(`n + 2 - `t1 + t)*`w+:`w] & A[(`n + 2 - `t2 + t)*`w+:`w]) ^ (A[(`n + 2 - `t3 + t)*`w+:`w] & A[(`n + 2 - `t4 + t)*`w+:`w]);
					x[3*`w-1:2*`w] = x[2*`w +:`w] ^ (x[2*`w +:`w] >> rshift[3*`b-1: 2*`b]);
					A[(`n + 2 +t)*`w +:`w] = x[2*`w+:`w] ^ (x[2*`w+:`w] << lshift[3*`b-1:2*`b]);
					
					x[4*`w-1:3*`w] = S[(j)*`w+:`w] ^ A [(3+ t)*`w+:`w] ^ A [(`n + 3 - `t0 + t)*`w+:`w];
					x[4*`w-1:3*`w] = x[3*`w +:`w] ^ (A[(`n + 3 - `t1 + t)*`w+:`w] & A[(`n + 3 - `t2 + t)*`w+:`w]) ^ (A[(`n + 3 - `t3 + t)*`w+:`w] & A[(`n + 3 - `t4 + t)*`w+:`w]);
					x[4*`w-1:3*`w] = x[3*`w +:`w] ^ (x[3*`w +:`w] >> rshift[4*`b-1: 3*`b]);
					A[(`n + 3 +t)*`w +:`w] = x[3*`w+:`w] ^ (x[3*`w+:`w] << lshift[4*`b-1:3*`b]);

					x[5*`w-1:4*`w] = S[(j)*`w+:`w] ^ A [(4+ t)*`w+:`w] ^ A [(`n + 4 - `t0 + t)*`w+:`w];
					x[5*`w-1:4*`w] = x[4*`w +:`w] ^ (A[(`n + 4 - `t1 + t)*`w+:`w] & A[(`n + 4 - `t2 + t)*`w+:`w]) ^ (A[(`n + 4 - `t3 + t)*`w+:`w] & A[(`n + 4 - `t4 + t)*`w+:`w]);
					x[5*`w-1:4*`w] = x[4*`w +:`w] ^ (x[4*`w +:`w] >> rshift[5*`b-1: 4*`b]);
					A[(`n + 4 +t)*`w +:`w] = x[4*`w+:`w] ^ (x[4*`w+:`w] << lshift[5*`b-1:4*`b]);

					x[6*`w-1:5*`w] = S[(j)*`w+:`w] ^ A [(5+ t)*`w+:`w] ^ A [(`n + 5 - `t0 + t)*`w+:`w];
					x[6*`w-1:5*`w] = x[5*`w +:`w] ^ (A[(`n + 5 - `t1 + t)*`w+:`w] & A[(`n + 5 - `t2 + t)*`w+:`w]) ^ (A[(`n + 5 - `t3 + t)*`w+:`w] & A[(`n + 5 - `t4 + t)*`w+:`w]);
					x[6*`w-1:5*`w] = x[5*`w +:`w] ^ (x[5*`w +:`w] >> rshift[6*`b-1: 5*`b]);
					A[(`n + 5 +t)*`w +:`w] = x[5*`w+:`w] ^ (x[5*`w+:`w] << lshift[6*`b-1:5*`b]);

					x[7*`w-1:6*`w] = S[(j)*`w+:`w] ^ A [(6+ t)*`w+:`w] ^ A [(`n + 6 - `t0 + t)*`w+:`w];
					x[7*`w-1:6*`w] = x[6*`w +:`w] ^ (A[(`n + 6 - `t1 + t)*`w+:`w] & A[(`n + 6 - `t2 + t)*`w+:`w]) ^ (A[(`n + 6 - `t3 + t)*`w+:`w] & A[(`n + 6 - `t4 + t)*`w+:`w]);
					x[7*`w-1:6*`w] = x[6*`w +:`w] ^ (x[6*`w +:`w] >> rshift[7*`b-1: 6*`b]);
					A[(`n + 6 +t)*`w +:`w] = x[6*`w+:`w] ^ (x[6*`w+:`w] << lshift[7*`b-1:6*`b]);

					x[8*`w-1:7*`w] = S[(j)*`w+:`w] ^ A [(7+ t)*`w+:`w] ^ A [(`n + 7 - `t0 + t)*`w+:`w];
					x[8*`w-1:7*`w] = x[7*`w +:`w] ^ (A[(`n + 7 - `t1 + t)*`w+:`w] & A[(`n + 7 - `t2 + t)*`w+:`w]) ^ (A[(`n + 7 - `t3 + t)*`w+:`w] & A[(`n + 7 - `t4 + t)*`w+:`w]);
					x[8*`w-1:7*`w] = x[7*`w +:`w] ^ (x[7*`w +:`w] >> rshift[8*`b-1: 7*`b]);
					A[(`n + 7 +t)*`w +:`w] = x[7*`w+:`w] ^ (x[7*`w+:`w] << lshift[8*`b-1:7*`b]);

					x[9*`w-1:8*`w] = S[(j)*`w+:`w] ^ A [(8+ t)*`w+:`w] ^ A [(`n + 8 - `t0 + t)*`w+:`w];
					x[9*`w-1:8*`w] = x[8*`w +:`w] ^ (A[(`n + 8 - `t1 + t)*`w+:`w] & A[(`n + 8 - `t2 + t)*`w+:`w]) ^ (A[(`n + 8 - `t3 + t)*`w+:`w] & A[(`n + 8 - `t4 + t)*`w+:`w]);
					x[9*`w-1:8*`w] = x[8*`w +:`w] ^ (x[8*`w +:`w] >> rshift[9*`b-1: 8*`b]);
					A[(`n + 8 +t)*`w +:`w] = x[8*`w+:`w] ^ (x[8*`w+:`w] << lshift[9*`b-1:8*`b]);

					x[10*`w-1:9*`w] = S[(j)*`w+:`w] ^ A [(9+ t)*`w+:`w] ^ A [(`n + 9 - `t0 + t)*`w+:`w];
					x[10*`w-1:9*`w] = x[9*`w +:`w] ^ (A[(`n + 9 - `t1 + t)*`w+:`w] & A[(`n + 9 - `t2 + t)*`w+:`w]) ^ (A[(`n + 9 - `t3 + t)*`w+:`w] & A[(`n + 9 - `t4 + t)*`w+:`w]);
					x[10*`w-1:9*`w] = x[9*`w +:`w] ^ (x[9*`w +:`w] >> rshift[10*`b-1: 9*`b]);
					A[(`n + 9 +t)*`w +:`w] = x[9*`w+:`w] ^ (x[9*`w+:`w] << lshift[10*`b-1:9*`b]);

					x[11*`w-1:10*`w] = S[(j)*`w+:`w] ^ A [(10+ t)*`w+:`w] ^ A [(`n + 10 - `t0 + t)*`w+:`w];
					x[11*`w-1:10*`w] = x[10*`w +:`w] ^ (A[(`n + 10 - `t1 + t)*`w+:`w] & A[(`n + 10 - `t2 + t)*`w+:`w]) ^ (A[(`n + 10 - `t3 + t)*`w+:`w] & A[(`n + 10 - `t4 + t)*`w+:`w]);
					x[11*`w-1:10*`w] = x[10*`w +:`w] ^ (x[10*`w +:`w] >> rshift[11*`b-1: 10*`b]);
					A[(`n + 10 +t)*`w +:`w] = x[10*`w+:`w] ^ (x[10*`w+:`w] << lshift[11*`b-1:10*`b]);

					x[12*`w-1:11*`w] = S[(j)*`w+:`w] ^ A [(11+ t)*`w+:`w] ^ A [(`n + 11 - `t0 + t)*`w+:`w];
					x[12*`w-1:11*`w] = x[11*`w +:`w] ^ (A[(`n + 11 - `t1 + t)*`w+:`w] & A[(`n + 11 - `t2 + t)*`w+:`w]) ^ (A[(`n + 11 - `t3 + t)*`w+:`w] & A[(`n + 11 - `t4 + t)*`w+:`w]);
					x[12*`w-1:11*`w] = x[11*`w +:`w] ^ (x[11*`w +:`w] >> rshift[12*`b-1: 11*`b]);
					A[(`n + 11 +t)*`w +:`w] = x[11*`w+:`w] ^ (x[11*`w+:`w] << lshift[12*`b-1:11*`b]);

					x[13*`w-1:12*`w] = S[(j)*`w+:`w] ^ A [(12+ t)*`w+:`w] ^ A [(`n + 12 - `t0 + t)*`w+:`w];
					x[13*`w-1:12*`w] = x[12*`w +:`w] ^ (A[(`n + 12 - `t1 + t)*`w+:`w] & A[(`n + 12 - `t2 + t)*`w+:`w]) ^ (A[(`n + 12 - `t3 + t)*`w+:`w] & A[(`n + 12 - `t4 + t)*`w+:`w]);
					x[13*`w-1:12*`w] = x[12*`w +:`w] ^ (x[12*`w +:`w] >> rshift[13*`b-1: 12*`b]);
					A[(`n + 12 +t)*`w +:`w] = x[12*`w+:`w] ^ (x[12*`w+:`w] << lshift[13*`b-1:12*`b]);

					x[14*`w-1:13*`w] = S[(j)*`w+:`w] ^ A [(13+ t)*`w+:`w] ^ A [(`n + 13 - `t0 + t)*`w+:`w];
					x[14*`w-1:13*`w] = x[13*`w +:`w] ^ (A[(`n + 13 - `t1 + t)*`w+:`w] & A[(`n + 13 - `t2 + t)*`w+:`w]) ^ (A[(`n + 13 - `t3 + t)*`w+:`w] & A[(`n + 13 - `t4 + t)*`w+:`w]);
					x[14*`w-1:13*`w] = x[13*`w +:`w] ^ (x[13*`w +:`w] >> rshift[14*`b-1: 13*`b]);
					A[(`n + 13 +t)*`w +:`w] = x[13*`w+:`w] ^ (x[13*`w+:`w] << lshift[14*`b-1:13*`b]);

					x[15*`w-1:14*`w] = S[(j)*`w+:`w] ^ A [(14+ t)*`w+:`w] ^ A [(`n + 14 - `t0 + t)*`w+:`w];
					x[15*`w-1:14*`w] = x[14*`w +:`w] ^ (A[(`n + 14 - `t1 + t)*`w+:`w] & A[(`n + 14 - `t2 + t)*`w+:`w]) ^ (A[(`n + 14 - `t3 + t)*`w+:`w] & A[(`n + 14 - `t4 + t)*`w+:`w]);
					x[15*`w-1:14*`w] = x[14*`w +:`w] ^ (x[14*`w +:`w] >> rshift[15*`b-1: 14*`b]);
					A[(`n + 14 +t)*`w +:`w] = x[14*`w+:`w] ^ (x[14*`w+:`w] << lshift[15*`b-1:14*`b]);

					x[16*`w-1:15*`w] = S[(j)*`w+:`w] ^ A [(15+ t)*`w+:`w] ^ A [(`n + 15 - `t0 + t)*`w+:`w];
					x[16*`w-1:15*`w] = x[15*`w +:`w] ^ (A[(`n + 15 - `t1 + t)*`w+:`w] & A[(`n + 15 - `t2 + t)*`w+:`w]) ^ (A[(`n + 15 - `t3 + t)*`w+:`w] & A[(`n + 15 - `t4 + t)*`w+:`w]);
					x[16*`w-1:15*`w] = x[15*`w +:`w] ^ (x[15*`w +:`w] >> rshift[16*`b-1: 15*`b]);
					A[(`n + 15 +t)*`w +:`w] = x[15*`w+:`w] ^ (x[15*`w+:`w] << lshift[16*`b-1:15*`b]);
					
					t <= t + `c;
					j <= j + 1;
				end
				else 
					done <= 1;
			end		
		endcase
	end
end

assign C = A[(`n + (R-1)*`c)*`w +:`c*`w];

endmodule
