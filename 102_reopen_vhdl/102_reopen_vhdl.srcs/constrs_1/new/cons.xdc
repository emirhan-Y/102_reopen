# Clock signal
set_property PACKAGE_PIN W5 [get_ports in_clk]							
	set_property IOSTANDARD LVCMOS33 [get_ports in_clk]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports in_clk]

# USB-RS232 Interface
set_property PACKAGE_PIN B18 [get_ports in_rx]						
	set_property IOSTANDARD LVCMOS33 [get_ports in_rx]
set_property PACKAGE_PIN A18 [get_ports out_tx]						
	set_property IOSTANDARD LVCMOS33 [get_ports out_tx]
	
set_property PACKAGE_PIN T1 [get_ports {in_trx_enable}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {in_trx_enable}]
set_property PACKAGE_PIN R2 [get_ports {in_chip_enable}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {in_chip_enable}]
	
# LEDs: Output monitoring
set_property PACKAGE_PIN U16 [get_ports {out_end_of_op_flag}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {out_end_of_op_flag}]
set_property PACKAGE_PIN E19 [get_ports {out_fatal_error}]					
	set_property IOSTANDARD LVCMOS33 [get_ports {out_fatal_error}]

