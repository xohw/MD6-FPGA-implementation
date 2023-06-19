`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 14/09/2022 
// Module Name: receiver
//
//Description:
//The data (Message,hash length,Key,Level,Rounds,keylen,padding,index_padd) will arrive one after the other
//as one batch.
//The message and key should be arranged in "big endian" way. 
//The "padding" is the amount of zeros to be padded for the last comperssion function (pre-calculated in software)
//The "index_padd" is an indicator for knowing where the comperssion function is.(also pre-calculated in software)
//
//Every time a piece of batch finished to arrive, a "done" signal "lights up" (it will be connected to a LED in the experimented board)
//
//all noted in the description is done in the second state of the state machine.
//
//
//
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module receiver
#( 	// constants
	parameter size_M = `wi*(64*`w),                                 // Number of bits in data to recieve 
	parameter size_d = 16,
	parameter size_K = 512,
	parameter size_L = 8,
	parameter size_r = 16,
	parameter size_keylen = 8,
	parameter size_padding = 16,
	parameter size_index_padd = 8,
	parameter byte_size_M = 	 $clog2(size_M/8),                  // Number of bytes in data
	parameter byte_size_d  = 	 $clog2(size_d/8),
	parameter byte_size_K  = 	 $clog2(size_K/8),
	parameter byte_size_L  = 	 $clog2(size_L/8),
	parameter byte_size_r  = 	 $clog2(size_r/8),
	parameter byte_size_keylen  = $clog2(size_keylen/8),
	parameter byte_size_padding = $clog2(size_padding/8),
	parameter byte_size_index_padd = $clog2(size_index_padd/8), 	
	parameter div_sample = 4,										// Oversampling
	parameter div_counter = `clk_freq / (`baud_rate * div_sample), 	// this is the number we have to divide the system clock frequency to get a frequency (div_sample) time higher than (baud_rate)
	parameter mid_sample = (div_sample / 2),  						// this is the middle point of a bit where you want to sample it
	parameter div_bit = 10 										    // 1 start, 8 data, 1 stop
 )
(
	input  wire 			 			clk, 						// input 100MHzclock 
	input  wire 			 			reset, 						// input reset
	input  wire				 			RxD, 						// input receving data line
	output wire [size_d-1:0] 			d,
	output wire [size_K-1:0] 			K,
	output wire [size_keylen-1:0]       keylen,
	output wire [size_L-1:0] 			L,
	output wire [size_r-1:0] 			r,
	output wire	[size_M-1:0] 			Message,
	output wire [size_padding-1:0]		padding_zero_M,
	output wire [size_index_padd-1:0]   index_padd,
	output reg 				 			done_M,
	output reg 				 			done_d,
	output reg 				 			done_K,
	output reg 				 			done_L,
	output reg 				 			done_r,
	output reg 				 			done_keylen,
	output reg 				 			done_padding,
	output reg 				 			done_rx  
);
    
//Registers
	reg  [size_M-1:0] 			 	data_reg_M = 0;					
	reg  [size_d-1:0]			 	data_reg_d = 0;					
	reg  [size_K-1:0]			 	data_reg_K = 0;
	reg  [size_L-1:0]			 	data_reg_L = 0;
	reg  [size_r-1:0]			 	data_reg_r = 0;
	reg  [size_keylen-1:0]		 	data_reg_keylen  = 0;
	reg  [size_padding-1:0]		 	data_reg_padding = 0;
	reg  [size_index_padd-1:0]	 	data_reg_index_padd = 0;

//bytes's arrival control		
	reg  [2:0] 			 	  	 	index_byte_M = 7;               // used to arrange the bytes in data in order to get "big endian" definition.
	reg  [byte_size_M + 1:0]  	 	word_M = 0;						// word_M indicates the number of bytes which were arrived.  					
	reg  [byte_size_d + 1:0]   	 	index_d = 0;					// indicate bytes's arrival
	reg  [2:0]  		 	  	 	index_byte_K = 7;
	reg  [byte_size_K + 1:0]   	 	word_K = 0;
	reg  [byte_size_L + 1:0]   	 	index_L = 0;
	reg  [byte_size_r + 1:0]   	 	index_r = 0;
	reg  [byte_size_keylen + 1:0]	index_keylen  = 0;
	reg  [byte_size_padding+1:0] 	index_padding = 0;
	reg  [byte_size_index_padd+1:0] index_index_padd = 0;

	
	reg  [13:0] 		 		 counter_delay = 0;                 // delay solver        

	reg shift; 														// shift signal to trigger shifting data
	reg state; 														// initial state  variable
	reg nextstate; 													// next state variable
	
	reg clear_bitcounter; 											// clear the counter
	reg inc_bitcounter;   											// increment the counter
	
	reg clear_samplecounter;								 		// clear the counter
	reg inc_samplecounter; 											// increment the counter
	
	reg [3:0] 	bitcounter; 										// 4 bits counter to count up to 9 for UART receiving
	reg [1:0] 	samplecounter; 										// 2 bits sample counter to count up to 4 for oversampling
	reg [13:0]  counter; 											// 14 bits counter to count the baud rate
	reg [9:0] 	rxshiftreg; 										// bit shifting register
	
	
	assign Message 			= data_reg_M;
	assign d 	   			= data_reg_d;
	assign K 	   			= data_reg_K;
	assign L 	   			= data_reg_L;
	assign r 	   			= data_reg_r;
    assign keylen  			= data_reg_keylen;
	assign padding_zero_M 	= data_reg_padding;
	assign index_padd      	= data_reg_index_padd;
	
	//UART receiver logic
	always @ (posedge clk)
		begin 
			if (reset)												// if reset is asserted
			begin 
				state <= 0;				 							// set state to idle 
				bitcounter <= 0;				 		    		// reset the bit counter
				counter <= 0;				 						// reset the counter
				samplecounter <= 0;				 					// reset the sample counter
			end 
			else													// if reset is not asserted
			begin 
				counter <= counter + 1; 							// start count in the counter
				if (counter >= div_counter - 1) 					// if counter reach the baud rate with sampling
				begin 
					counter <= 0; 									// reset the counter
					state <= nextstate; 							// assign the state to nextstate
					if (shift)										// if shift asserted, load the receiving data
						rxshiftreg <= {RxD,rxshiftreg[9:1]}; 		
					if (clear_samplecounter)						// if clear sampl counter asserted, reset sample counter
						samplecounter <= 0; 						
					if (inc_samplecounter)							// if increment counter asserted, start sample count
						samplecounter <= samplecounter  + 1;	    
					if (clear_bitcounter) 							// if clear bit counter asserted, reset bit counter
						bitcounter <= 0; 							
					if (inc_bitcounter)								// if increment bit counter asserted, start count bit counter
						bitcounter <= bitcounter + 1;					
				end
			end
		end
	   
//state machin


	always @ (posedge clk) 											//trigger by clock
	begin 
		shift <= 0; 												// set shift to 0 to avoid any shifting 
		clear_samplecounter <= 0; 									// set clear sample counter to 0 to avoid reset 							
		clear_bitcounter <= 0; 										// set clear bit counter to 0 to avoid claring
		inc_bitcounter <= 0; 										// set increment bit counter to avoid any count
		nextstate <=0; 												// set next state to be idle state
		if(reset)
		begin
			shift <= 0; 					
			clear_samplecounter <= 0; 		
			clear_bitcounter <= 0; 			
			inc_bitcounter <= 0; 			
			nextstate <=0; 
			inc_samplecounter <= 0;                                 // set increment samplecounter to 0
			done_M 			  <= 0;
			done_d 			  <= 0;
			done_K 			  <= 0;
			done_L 			  <= 0;
			done_r 			  <= 0;
			done_keylen 	  <= 0;
			done_padding	  <= 0;
			done_rx			  <= 0;
			word_M            <= 0;
			index_byte_M      <= 7;
			data_reg_M        <= 0;
			index_d           <= 0;
			data_reg_d        <= 0;
			word_K            <= 0;
			index_byte_K      <= 7;
			data_reg_K        <= 0;
			index_L           <= 0;
			data_reg_L        <= 0;
			index_r           <= 0;
			data_reg_r        <= 0;
			index_keylen      <= 0;
			data_reg_keylen   <= 0;
			index_padding     <= 0;
			data_reg_padding  <= 0;
			data_reg_index_padd<= 0;
			index_index_padd   <= 0;

		end
		case (state)
			0: 														// idle state
			begin 
				if (RxD) 											// if input RxD data line asserted
					nextstate <= 0; 									// back to idle state because RxD needs to be low to start transmission
			    else 
				begin 												// if input RxD data line is not asserted
					nextstate <= 1; 								// jump to receiving state
					clear_samplecounter <= 1; 						// trigger to clear sample counter
					clear_bitcounter <= 1;
				end
			end
			1: 
			begin 													// receiving state
				nextstate <= 1; 									// DEFAULT 
				if (samplecounter== mid_sample - 1)					// if sample counter is 1, trigger shift 
					shift <= 1; 									
					if (samplecounter== div_sample - 1) 			// if sample counter is 3 as the sample rate used is 3
					begin 
						if (bitcounter == div_bit - 1) 				// check if bit counter is 9 or not
						begin
							if (word_M<512)
							begin
								data_reg_M [(word_M+index_byte_M)*8 +: 8] <= rxshiftreg [8:1];  // put one byte into register data out
								nextstate <= 0; 												// back to idle state if bit counter is 9 as receving is complete
								if (counter_delay == (div_counter - 1)) 						// in order to increment "index byte" one time only
								begin
									if (index_byte_M != 0) 
									index_byte_M <= index_byte_M - 1;        		            // manage next byte (big endian operation)
									if (index_byte_M == 0)
									begin
										word_M  <= word_M + 8;
										index_byte_M <= 7;
									end
									counter_delay <= 0;
								end
								else
									counter_delay <= counter_delay + 1;	
							end
							else if (index_d<2)
							begin
								done_M <= 1;
								data_reg_d [(index_d)*8 +: 8] <= rxshiftreg [8:1];  			// put one byte into register data out
								nextstate <= 0; 												// back to idle state if bit counter is 9 as receving is complete
								if (counter_delay == (div_counter - 1)) 						// in order to increment "index byte" one time only
								begin			
									index_d <= index_d + 1;                 					// manage next byte
									counter_delay <= 0;
								end
								else
									counter_delay <= counter_delay + 1;
							end
							else if (word_K<64)
							begin
								done_d <= 1;
								data_reg_K [(word_K + index_byte_K)*8 +: 8] <= rxshiftreg [8:1];  // put one byte into register data out
								nextstate <= 0; 												  // back to idle state if bit counter is 9 as receving is complete
								if (counter_delay == (div_counter - 1)) 						  // in order to increment "index byte" one time only
								begin
									if (index_byte_K != 0)
									index_byte_K <= index_byte_K - 1;           			      // manage next byte (big endian operation)
									if (index_byte_K == 0)
									begin
										word_K  <= word_K + 8;
										index_byte_K <= 7;
									end
									counter_delay <= 0;
								end
								else
									counter_delay <= counter_delay + 1;
							end
							else if (index_L<1)
							begin
								done_K <= 1;
								data_reg_L [(index_L)*8 +: 8] <= rxshiftreg [8:1];  			 // put one byte into register data out
								nextstate <= 0; 												 // back to idle state if bit counter is 9 as receving is complete
								if (counter_delay == (div_counter - 1)) 						 // in order to increment "index byte" one time only
								begin
									index_L <= index_L + 1;                						 // manage next byte
									counter_delay <= 0;
								end
								else
									counter_delay <= counter_delay + 1;
							end
							else if (index_r<2)
							begin
								done_L <= 1;
								data_reg_r [(index_r)*8 +: 8] <= rxshiftreg [8:1];  			 // put one byte into register data out
								nextstate <= 0; 												 // back to idle state if bit counter is 9 as receving is complete
								if (counter_delay == (div_counter - 1)) 						 // in order to increment "index byte" one time only
								begin
									index_r <= index_r + 1;                						 // manage next byte
									counter_delay <= 0;
								end
								else
									counter_delay <= counter_delay + 1;
							end
							else if (index_keylen<1)
							begin
								done_r <= 1;
								data_reg_keylen [(index_keylen)*8 +: 8] <= rxshiftreg [8:1];    // put one byte into register data out
								nextstate <= 0; 												// back to idle state if bit counter is 9 as receving is complete
								if (counter_delay == (div_counter - 1)) 						// in order to increment "index byte" one time only
								begin
									index_keylen <= index_keylen + 1;                 			// manage next byte
									counter_delay <= 0;
								end
								else
									counter_delay <= counter_delay + 1;
							end
							else if (index_padding<2)
							begin
								done_keylen <= 1;
								data_reg_padding [(index_padding)*8 +: 8] <= rxshiftreg [8:1];  // put one byte into register data out
								nextstate <= 0; 												// back to idle state if bit counter is 9 as receving is complete
								if (counter_delay == (div_counter - 1)) 						// in order to increment "index byte" one time only
								begin
									index_padding <= index_padding + 1;                 		// manage next byte
									counter_delay <= 0;
								end
								else
									counter_delay <= counter_delay + 1;
							end
							else if (index_index_padd<1)
							begin
								done_padding <= 1;
								done_rx <= 1;
								data_reg_index_padd [(index_index_padd)*8 +: 8] <= rxshiftreg [8:1];// put one byte into register data out
								nextstate <= 0; 													// back to idle state if bit counter is 9 as receving is complete
								if (counter_delay == (div_counter - 1)) 							// in order to increment "index byte" one time only
								begin
									index_index_padd <= index_index_padd + 1;               	    // manage next byte
									counter_delay <= 0;
								end
								else
									counter_delay <= counter_delay + 1;
							end						
						end 
						inc_bitcounter <= 1; 						// trigger the increment bit counter if bit counter is not 9
						clear_samplecounter <= 1; 					//trigger the sample counter to reset the sample counter
					end	
				else 
					inc_samplecounter <= 1; 						// if sample is not equal to 3, keep counting
			end			
		   default: nextstate <= 0; 								//default idle state
		 endcase
	end         
	endmodule
