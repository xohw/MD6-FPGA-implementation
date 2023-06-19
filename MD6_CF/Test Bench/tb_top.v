///////////////////////////////////
// Verilog testbench
///////////////////////////////////

`timescale	1ns/1ps

module tb_top
(
);
reg  tb_clk, tb_reset;
reg  button_tx;
reg  tb_RxD;
wire tb_done_M;
wire tb_done_d;
wire tb_done_K;
wire tb_done_L;
wire tb_done_r;
wire tb_done_keylen;
wire tb_done_padding;
wire tb_done_rx;
wire tb_done_MD6;
wire tb_TxD;

initial begin
//  $display ("time\t\t  clk reset	 btn 	 rx 	 tx   ");
//  $monitor ("%8g\t\t%b   %b    %b	%b	%b", 
//	  $time, tb_clk, tb_reset, button_tx , tb_RxD , tb_TxD);	        	
  tb_clk             = 1; 
  tb_reset           = 1;
  button_tx 		 = 0;
  #700   tb_reset    = 0;
  
// message arrival
  #0	    tb_RxD   = 1;
  
  //"a"
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1; 
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 1;
  #104166   tb_RxD   = 1;
  #104166   tb_RxD   = 0;

  #104166   tb_RxD   = 1;  
  
  //"b"
  #104166   tb_RxD   = 0;  
  
  #104166   tb_RxD   = 0; 
  #104166   tb_RxD   = 1;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 1;
  #104166   tb_RxD   = 1;
  #104166   tb_RxD   = 0;

  #104166   tb_RxD   = 1;

  //"c"  
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 1;
  #104166   tb_RxD   = 1;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 1;
  #104166   tb_RxD   = 1;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
///////////////////////// M_2

 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 ///////////////////////// M_3

 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
  
 /////////////////////// M_4

 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
 
 // padding zeros
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;

///////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// d - length of hash arrive 
// first d byte
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
// second d byte  
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;

// Key 
// first K byte
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
  
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;

  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
  
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
  #104166   tb_RxD   = 0; 
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;

// Level 
// first L byte
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 1; //"=1" to get L=64
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
// rounds 
// first r byte
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 1;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
  
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
//   keylen
  
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
// index padding  
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 1;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 1;
  #104166   tb_RxD   = 1;
  #104166   tb_RxD   = 1;
  
  #104166   tb_RxD   = 1; 
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
  #104166   tb_RxD   = 1;
  #104166   tb_RxD   = 1; //=1 to get 4072. =0 to get 4072 - 1024
  #104166   tb_RxD   = 1;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
// index index pad  
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  #104166   tb_RxD   = 0;
  
  #104166   tb_RxD   = 1;
  //transmit
  #500000   button_tx  = 1;  
end

always begin
   #5  tb_clk = ~tb_clk; 
end

// Connect DUT to test bench
top DUT 
(
tb_clk  ,
tb_reset,
button_tx,
tb_RxD,
tb_done_M,
tb_done_d,
tb_done_K,
tb_done_L,
tb_done_r,
tb_done_keylen,
tb_done_padding,
tb_done_rx,
tb_done_MD6,
tb_TxD
);
  
endmodule
