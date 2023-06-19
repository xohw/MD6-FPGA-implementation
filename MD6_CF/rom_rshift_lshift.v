`timescale 1ns / 1ps

module rom_rshift_lshift
    (
        output wire [16*8-1 : 0] rshift,
		output wire [16*8-1 : 0] lshift
    );

	rom_l				T1
	(
		.addr_a(4'b0),
		.data_a(lshift)
	);
	
	rom_r				T2
	(
		.addr_a(4'b0),
		.data_a(rshift)
	);
endmodule

module rom_l
    #(parameter ADDR_WIDTH = 4, DATA_WIDTH = 128)
    (
        input [ADDR_WIDTH - 1 : 0] addr_a,
        output reg [DATA_WIDTH - 1 : 0] data_a
    );

    (*rom_style = "distributed"*) reg [DATA_WIDTH - 1 : 0] rom [0: 2**ADDR_WIDTH - 1]; //width,depth
     
    initial
        $readmemh("rom_l.mem",rom);
    
    always @(*)
    begin 
        data_a <= rom[addr_a];
    end
endmodule 

module rom_r
    #(parameter ADDR_WIDTH = 4, DATA_WIDTH = 128)
    (
        input [ADDR_WIDTH - 1 : 0] addr_a,
        output reg [DATA_WIDTH - 1 : 0] data_a
    );

    (*rom_style = "distributed"*) reg [DATA_WIDTH - 1 : 0] rom [0: 2**ADDR_WIDTH - 1]; //width,depth
     
    initial
        $readmemh("rom_r.mem",rom);
    
    always @(*)
    begin 
        data_a <= rom[addr_a];
    end
endmodule 

