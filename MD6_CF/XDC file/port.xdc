##########
# Clocks #
##########
create_clock -name 	clk -period 10 -waveform {0 5} [get_ports clk]

###############
# Input Delay #
###############
#set_input_delay 0 -clock clk  -add_delay  [get_ports {RxD reset button_rx button_tx}]

################
# Output Delay #
################
#set_output_delay 0 -clock clk  -add_delay  [get_ports {TxD done_M done_d done_K done_L done_r done_keylen done_padding done_rx}]


##############################
# Pin Locations and Voltages #
##############################
set_property -dict { PACKAGE_PIN W5  IOSTANDARD LVCMOS33 } [get_ports { clk    }]; 

#UART PORT
set_property -dict { PACKAGE_PIN A18 IOSTANDARD LVCMOS33 } [get_ports { TxD    }];
set_property -dict { PACKAGE_PIN B18 IOSTANDARD LVCMOS33 } [get_ports { RxD    }];

#INPUT-BTNU
set_property -dict { PACKAGE_PIN T18 IOSTANDARD LVCMOS33 } [get_ports { reset  }];

#INPUT-BTNC
set_property -dict { PACKAGE_PIN U18 IOSTANDARD LVCMOS33 } [get_ports { button_tx }];

#INPUT-LD0
set_property -dict { PACKAGE_PIN U16 IOSTANDARD LVCMOS33 } [get_ports { done_M }];

#INPUT-LD1
set_property -dict { PACKAGE_PIN E19 IOSTANDARD LVCMOS33 } [get_ports { done_d }];

#INPUT-LD2
set_property -dict { PACKAGE_PIN U19 IOSTANDARD LVCMOS33 } [get_ports { done_K }];

#INPUT-LD3
set_property -dict { PACKAGE_PIN V19 IOSTANDARD LVCMOS33 } [get_ports { done_L }];

#INPUT-LD4
set_property -dict { PACKAGE_PIN W18 IOSTANDARD LVCMOS33 } [get_ports { done_r }];

#INPUT-LD5
set_property -dict { PACKAGE_PIN U15 IOSTANDARD LVCMOS33 } [get_ports { done_keylen }];

#INPUT-LD6
set_property -dict { PACKAGE_PIN U14 IOSTANDARD LVCMOS33 } [get_ports { done_padding }];

#INPUT-LD7
set_property -dict { PACKAGE_PIN V14 IOSTANDARD LVCMOS33 } [get_ports { done_rx }];

#INPUT-LD8
set_property -dict { PACKAGE_PIN V13 IOSTANDARD LVCMOS33 } [get_ports { done_MD6}];

##########################
# Configuration Settings #
##########################
set_property CFGBVS VCCO [current_design]
set_property CONFIG_VOLTAGE 3.3 [current_design]






