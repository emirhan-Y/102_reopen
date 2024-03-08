# Clock signal
set_property PACKAGE_PIN W5 [get_ports in_100MHz_clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports in_100MHz_clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports in_100MHz_clk]

# USB-RS232 Interface
set_property PACKAGE_PIN B18 [get_ports in_rx]						
	set_property IOSTANDARD LVCMOS33 [get_ports in_rx]
#set_property PACKAGE_PIN A18 [get_ports out_tx]						
	#set_property IOSTANDARD LVCMOS33 [get_ports out_tx]
	
# LEDs: Output monitoring
set_property PACKAGE_PIN U16 [get_ports {out_byte[0]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {out_byte[0]}]
set_property PACKAGE_PIN E19 [get_ports {out_byte[1]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {out_byte[1]}]
set_property PACKAGE_PIN U19 [get_ports {out_byte[2]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {out_byte[2]}]
set_property PACKAGE_PIN V19 [get_ports {out_byte[3]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {out_byte[3]}]
set_property PACKAGE_PIN W18 [get_ports {out_byte[4]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {out_byte[4]}]
set_property PACKAGE_PIN U15 [get_ports {out_byte[5]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {out_byte[5]}]
set_property PACKAGE_PIN U14 [get_ports {out_byte[6]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {out_byte[6]}]
set_property PACKAGE_PIN V14 [get_ports {out_byte[7]}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {out_byte[7]}]
