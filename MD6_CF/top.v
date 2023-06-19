`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 14/09/2022 
// Module Name: top
// Description: wrapper of the MD6 algo and the UART protocol
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module top 
(
	input 	wire	clk,
	input 	wire 	reset,
	input 	wire 	button_tx,
	input 	wire 	RxD,
	output  wire	done_M,			// all done siganls are going to the board's LEDs 
	output  wire	done_d,
	output  wire	done_K,
	output  wire	done_L,
	output  wire	done_r,
	output  wire	done_keylen,
	output  wire	done_padding,
	output  wire    done_rx,
	output  wire    done_MD6,
	output	wire 	TxD
); 

	wire  					transmit_en;	
	wire  [`wi*(64*`w)-1:0] Message;
	wire  [511:0] 			hash;
	wire  [15:0] 			d;
	wire  [511:0]			K;
	wire  [7:0]  			keylen;
	wire  [7:0]  			L;
	wire  [15:0] 			r;
	wire  [15:0] 			padding_zero_M;
	wire  [7:0] 			index_padd;

	button_debouncing T1 
	(
		.clk(clk),
		.button_tx(button_tx),
		.transmit_en(transmit_en)
	);
	
	receiver	T2
	(
		.clk(clk),
		.reset(reset),
		.RxD(RxD),
		.d(d),
		.K(K),
		.keylen(keylen),
		.L(L),
		.r(r),
		.Message(Message),
		.padding_zero_M(padding_zero_M),
		.index_padd(index_padd),
		.done_M(done_M),
		.done_d(done_d),
		.done_K(done_K),
		.done_L(done_L),
		.done_r(done_r),
		.done_keylen(done_keylen),
		.done_padding(done_padding),
		.done_rx(done_rx)
	);
	
	MD6_Mode 	T3
	(
		.clk(clk),
		.reset(reset),
		.enable(done_rx),
		.d(d[11:0]),
		.K(K),
		.keylen(keylen),
		.L(L),
		.r(r[11:0]),
		.M(Message),
		.padding_zero_M(padding_zero_M),
		.index_padd(index_padd),
		.D(hash),
		.done_MD6(done_MD6)
	);
	
	transmiter	T4
	(
		.clk(clk),
		.reset(reset),
		.transmit(transmit_en),
		.d(d),
		.data(hash),
		.TxD(TxD)
	);
	


endmodule
