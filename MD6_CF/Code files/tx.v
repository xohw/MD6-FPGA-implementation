`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Create Date: 14/09/2022 
// Module Name: transmiter
//////////////////////////////////////////////////////////////////////////////////
`include "parameters.vh"

module transmiter
#(  
	parameter size = 512,
	parameter size_10 = (size/8)*10,
	parameter bit_size = $clog2(size/8)	
 )
(
	input  wire			clk, 							// UART input clock
	input  wire			reset, 							// reset signal
	input  wire			transmit, 						// btn signal to trigger the UART communication
	input  wire  [15:0] d,
	input  wire	[511:0]	data, 						    // data transmitted
	output reg			TxD 							// Transmitter serial output. TxD will be held high during reset, or when no transmissions aretaking place. 
);

	//internal variables
	reg [10:0] 	bitcounter; 							// 4 bits counter to count up to 10
	reg [13:0] 	counter; 								// 14 bits counter to count the baud rate, counter = clock / baud rate
	
	reg state; 											// initial state variable
	reg	nextstate; 										// next state variable
	
														// 10 bits data needed to be shifted out during transmission.
														// The least significant bit is initialized with the binary value “0” (a start bit) A binary value “1” is introduced in the most significant bit 
	reg [size_10-1:0] rightshiftreg; 
	reg shift; 											// shift signal to start bit shifting in UART
	reg load;											// load signal to start loading the data into rightshift register and add start and stop bit
	reg clear; 											// clear signal to start reset the bitcounter for UART transmission
	reg [bit_size:0] index;                             // used to seperate the bytes in data 
	reg [bit_size:0 ]index_reg;
	
	
	//UART transmission logic
	always @ (posedge clk) 
	begin 
		if (reset)  									// reset is asserted (reset = 1)
		begin
			state <= 0; 								// state is idle (state = 0)
			counter <= 0; 								// counter for baud rate is reset to 0 
			bitcounter <= 0; 							// counter for bit transmission is reset to 0
		end
		else 
		begin
			counter <= counter + 1; 					// counter for baud rate generator start counting 
			if (counter >= 10415) 						// if count to 10416 (from 0 to 10415)
			begin 
			  state <= nextstate; 						// previous state change to next state
			  counter <= 0; 							// reset couter to 0
			  if (load)	                                // load the data if load is asserted
			  begin 
			    index = 0;
				index_reg = size/8 -1;
				while (index < (size/8))
				begin
						rightshiftreg[index_reg*10 +: 10] <= {1'b1, data[index*8 +: 8], 1'b0}; // put the current data in register for transmission
					index = index + 1;                  // move to next byte
					index_reg = index_reg - 1;
				end
			  end
			  if (clear)								// reset the bitcounter if clear is asserted
				bitcounter <= 0; 
			  if (shift) 								// if shift is asserted
			  begin
				rightshiftreg <= rightshiftreg >> 1; 	// right shift the data as we transmit the data from lsb
				bitcounter <= bitcounter + 1; 			// count the bitcounter
			  end
			end
		end
	end 

	//state machine

	always @ (posedge clk) 								// trigger by positive edge of clock, 
	//always @ (state or bitcounter or transmit)
	begin
		load <= 0; 										// set load equal to 0 at the beginning
		shift <= 0; 									// set shift equal to 0 at the beginning
		clear <= 0; 									// set clear equal to 0 at the beginning
		TxD <= 1;   									// set TxD equals to during no transmission
		if (reset)
		begin
		load <= 0; 	
		shift <= 0; 
		clear <= 0; 
		TxD <= 1;   
		end
		case (state)
			0: 											// idle state
			begin 
				if (transmit)							// assert transmit input
				begin 									
					nextstate <= 1; 					// Move to transmit state
					load <= 1; 							// set load to 1 to prepare to load the data
					shift <= 0; 						// set shift to 0 so no shift ready yet
					clear <= 0; 						// set clear to 0 to avoid clear any counter
				end 
				else									// if transmit not asserted
				begin 
					nextstate <= 0; 					// next state is back to idle state
					TxD <= 1; 
				end
			end
			1: 											// transmit state
			begin  
				if (bitcounter >= (d/8)*10)				// check if transmission is complete or not. If complete
				begin 									
					nextstate <= 0; 					// set nextstate back to 0 to idle state
					clear <= 1; 						// set clear to 1 to clear all counters
			        index <= 0;
				end 
				else									// if transmisssion is not complete 
				begin 
					nextstate <= 1; 					// set nextstate to 1 to stay in transmit state
					TxD <= rightshiftreg[0]; 			// shift the bit to output TxD
					shift <= 1; 						// set shift to 1 to continue shifting the data
					load <= 0;
				end
			end
			default: nextstate <= 0;                      
		endcase
	end


endmodule

