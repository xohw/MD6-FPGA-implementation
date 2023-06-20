//fpga4student.com
// FPGA projects, Verilog projects, VHDL projects
// Verilog code for button debouncing on FPGA
// debouncing module 
module button_debouncing
(
	input  wire	clk,
	input  wire	button_tx,
	output wire	transmit_en
);
	wire 		rise_slow_clk;
	wire 		slow_clk;
	wire 		Q1,Q2,Q2_bar,Q0;
	
	
	clock_div u1
	(
		.clk_100M(clk),
		.rise_slow_clk(rise_slow_clk),
		.slow_clk(slow_clk)
	);
	
	
	my_dff d0
	(
		.clk_100M(clk),
		.enable(slow_clk),
		.rise(rise_slow_clk),
		.D(button_tx),
		.Q(Q0)
	);

	my_dff d1
	(
		.clk_100M(clk),
		.enable(slow_clk),
		.rise(rise_slow_clk),
		.D(Q0),
		.Q(Q1)
	);
	
	my_dff d2
	(
		.clk_100M(clk),
		.enable(slow_clk),
		.rise(rise_slow_clk),
		.D(Q1),
		.Q(Q2)
	);
	
	assign Q2_bar = ~Q2;
	assign transmit_en = Q1 & Q2_bar;
	
endmodule
	
	// Slow clock for debouncing 
	module clock_div
	(
		input  wire			clk_100M,
		output reg 			rise_slow_clk,
		output reg			slow_clk
	);
		reg [25:0]counter = 0;
		
		initial
		begin
			rise_slow_clk = 0;
		end
		
		always @(posedge clk_100M)
		begin
			if(counter >= 124999)
				counter <= 0;
			else
				counter <= counter + 1;
			if(counter < 67250)
				slow_clk <= 1'b0;
			else
				slow_clk <= 1'b1;
			if (counter == 67250)
				rise_slow_clk <= 1;
			else
				rise_slow_clk <= 0;
		end
		
	endmodule
	// D-flip-flop for debouncing module 
	module my_dff
	(
		input wire			clk_100M,
		input wire  		enable,
		input wire 			rise,
		input wire			D,
		output reg 			Q
	);

		always @ (posedge clk_100M)
		begin
			if(enable && rise)
				Q <= D;
		end

	endmodule