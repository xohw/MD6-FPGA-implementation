module S
#(parameter ADDR_WIDTH = 1, DATA_WIDTH = 1024)
(
	output wire [11*DATA_WIDTH - 1 : 0] S_out
);

	wire [`c*`w-1:0]  			s1_to_s;	
	wire [`c*`w-1:0]  			s2_to_s;	
	wire [`c*`w-1:0]  			s3_to_s;	
	wire [`c*`w-1:0]  			s4_to_s;
	wire [`c*`w-1:0]  			s5_to_s;	
	wire [`c*`w-1:0]  			s6_to_s;	
	wire [`c*`w-1:0]  			s7_to_s;	
	wire [`c*`w-1:0]  			s8_to_s;
	wire [`c*`w-1:0]  			s9_to_s;	
	wire [`c*`w-1:0]  			s10_to_s;	
	wire [`c*`w-1:0]  			s11_to_s;	
	
	assign S_out = {s11_to_s,s10_to_s,s9_to_s,s8_to_s,s7_to_s,s6_to_s,s5_to_s,s4_to_s,s3_to_s,s2_to_s,s1_to_s};
    
    rom_S1				T1
	(
		.addr_a(4'b0),
		.data_a(s1_to_s)
	);

	rom_S2				T2
	(
		.addr_a(4'b0),
		.data_a(s2_to_s)
	);
	rom_S3				T3
	(
		.addr_a(4'b0),
		.data_a(s3_to_s)
	);
	rom_S4				T4
	(
		.addr_a(4'b0),
		.data_a(s4_to_s)
	);
	rom_S5				T5
	(
		.addr_a(4'b0),
		.data_a(s5_to_s)
	);
	rom_S6				T6
	(
		.addr_a(4'b0),
		.data_a(s6_to_s)
	);
	rom_S7				T7
	(
		.addr_a(4'b0),
		.data_a(s7_to_s)
	);
	rom_S8				T8
	(
		.addr_a(4'b0),
		.data_a(s8_to_s)
	);
	rom_S9				T9
	(
		.addr_a(4'b0),
		.data_a(s9_to_s)
	);
	rom_S10				T10
	(
		.addr_a(4'b0),
		.data_a(s10_to_s)
	);	
	rom_S11				T11
	(
		.addr_a(4'b0),
		.data_a(s11_to_s)
	);
	
endmodule	
module rom_S1
    #(parameter ADDR_WIDTH = 4, DATA_WIDTH = 1024)
    (
        input [ADDR_WIDTH - 1 : 0] addr_a,
        output reg [DATA_WIDTH - 1 : 0] data_a
    );

    (*rom_style = "distributed"*) reg [DATA_WIDTH - 1 : 0] rom [0: 2**ADDR_WIDTH - 1]; //width,depth
     
    initial
        $readmemh("rom_S1.mem",rom);
    
    always @(*)
    begin 
        data_a <= rom[addr_a];
    end
endmodule 

module rom_S2
    #(parameter ADDR_WIDTH = 4, DATA_WIDTH = 1024)
    (
        input [ADDR_WIDTH - 1 : 0] addr_a,
        output reg [DATA_WIDTH - 1 : 0] data_a
    );

    (*rom_style = "distributed"*) reg [DATA_WIDTH - 1 : 0] rom [0: 2**ADDR_WIDTH - 1]; //width,depth
     
    initial
        $readmemh("rom_S2.mem",rom);
    
    always @(*)
    begin 
        data_a <= rom[addr_a];
    end
endmodule 

module rom_S3
    #(parameter ADDR_WIDTH = 4, DATA_WIDTH = 1024)
    (
        input [ADDR_WIDTH - 1 : 0] addr_a,
        output reg [DATA_WIDTH - 1 : 0] data_a
    );

    (*rom_style = "distributed"*) reg [DATA_WIDTH - 1 : 0] rom [0: 2**ADDR_WIDTH - 1]; //width,depth
     
    initial
        $readmemh("rom_S3.mem",rom);
    
    always @(*)
    begin 
        data_a <= rom[addr_a];
    end
endmodule 

module rom_S4
    #(parameter ADDR_WIDTH = 4, DATA_WIDTH = 1024)
    (
        input [ADDR_WIDTH - 1 : 0] addr_a,
        output reg [DATA_WIDTH - 1 : 0] data_a
    );

    (*rom_style = "distributed"*) reg [DATA_WIDTH - 1 : 0] rom [0: 2**ADDR_WIDTH - 1]; //width,depth
     
    initial
        $readmemh("rom_S4.mem",rom);
    
    always @(*)
    begin 
        data_a <= rom[addr_a];
    end
endmodule 

module rom_S5
    #(parameter ADDR_WIDTH = 4, DATA_WIDTH = 1024)
    (
        input [ADDR_WIDTH - 1 : 0] addr_a,
        output reg [DATA_WIDTH - 1 : 0] data_a
    );

    (*rom_style = "distributed"*) reg [DATA_WIDTH - 1 : 0] rom [0: 2**ADDR_WIDTH - 1]; //width,depth
     
    initial
        $readmemh("rom_S5.mem",rom);
    
    always @(*)
    begin 
        data_a <= rom[addr_a];
    end
endmodule 

module rom_S6
    #(parameter ADDR_WIDTH = 4, DATA_WIDTH = 1024)
    (
        input [ADDR_WIDTH - 1 : 0] addr_a,
        output reg [DATA_WIDTH - 1 : 0] data_a
    );

    (*rom_style = "distributed"*) reg [DATA_WIDTH - 1 : 0] rom [0: 2**ADDR_WIDTH - 1]; //width,depth
     
    initial
        $readmemh("rom_S6.mem",rom);
    
    always @(*)
    begin 
        data_a <= rom[addr_a];
    end
endmodule 

module rom_S7
    #(parameter ADDR_WIDTH = 4, DATA_WIDTH = 1024)
    (
        input [ADDR_WIDTH - 1 : 0] addr_a,
        output reg [DATA_WIDTH - 1 : 0] data_a
    );

    (*rom_style = "distributed"*) reg [DATA_WIDTH - 1 : 0] rom [0: 2**ADDR_WIDTH - 1]; //width,depth
     
    initial
        $readmemh("rom_S7.mem",rom);
    
    always @(*)
    begin 
        data_a <= rom[addr_a];
    end
endmodule 

module rom_S8
    #(parameter ADDR_WIDTH = 4, DATA_WIDTH = 1024)
    (
        input [ADDR_WIDTH - 1 : 0] addr_a,
        output reg [DATA_WIDTH - 1 : 0] data_a
    );

    (*rom_style = "distributed"*) reg [DATA_WIDTH - 1 : 0] rom [0: 2**ADDR_WIDTH - 1]; //width,depth
     
    initial
        $readmemh("rom_S8.mem",rom);
    
    always @(*)
    begin 
        data_a <= rom[addr_a];
    end
endmodule 

module rom_S9
    #(parameter ADDR_WIDTH = 4, DATA_WIDTH = 1024)
    (
        input [ADDR_WIDTH - 1 : 0] addr_a,
        output reg [DATA_WIDTH - 1 : 0] data_a
    );

    (*rom_style = "distributed"*) reg [DATA_WIDTH - 1 : 0] rom [0: 2**ADDR_WIDTH - 1]; //width,depth
     
    initial
        $readmemh("rom_S9.mem",rom);
    
    always @(*)
    begin 
        data_a <= rom[addr_a];
    end
endmodule 

module rom_S10
    #(parameter ADDR_WIDTH = 4, DATA_WIDTH = 1024)
    (
        input [ADDR_WIDTH - 1 : 0] addr_a,
        output reg [DATA_WIDTH - 1 : 0] data_a
    );

    (*rom_style = "distributed"*) reg [DATA_WIDTH - 1 : 0] rom [0: 2**ADDR_WIDTH - 1]; //width,depth
     
    initial
        $readmemh("rom_S10.mem",rom);
    
    always @(*)
    begin 
        data_a <= rom[addr_a];
    end
endmodule 

module rom_S11
    #(parameter ADDR_WIDTH = 4, DATA_WIDTH = 1024)
    (
        input [ADDR_WIDTH - 1 : 0] addr_a,
        output reg [DATA_WIDTH - 1 : 0] data_a
    );

    (*rom_style = "distributed"*) reg [DATA_WIDTH - 1 : 0] rom [0: 2**ADDR_WIDTH - 1]; //width,depth
     
    initial
        $readmemh("rom_S11.mem",rom);
    
    always @(*)
    begin 
        data_a <= rom[addr_a];
    end
endmodule 
