# Clock 50 MHz
set_property PACKAGE_PIN N11 [get_ports clk]
set_property IOSTANDARD LVCMOS33 [get_ports clk]

# Switches
set_property PACKAGE_PIN L5 [get_ports sw_q]       
set_property IOSTANDARD LVCMOS33 [get_ports sw_q]

set_property PACKAGE_PIN L4 [get_ports sw_at]      
set_property IOSTANDARD LVCMOS33 [get_ports sw_at]

# LED
set_property PACKAGE_PIN J3 [get_ports led]
set_property IOSTANDARD LVCMOS33 [get_ports led]

# Botón de reset
set_property PACKAGE_PIN M14 [get_ports rst]
set_property IOSTANDARD LVCMOS33 [get_ports rst]
